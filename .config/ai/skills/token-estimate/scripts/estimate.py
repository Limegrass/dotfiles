#!/usr/bin/env python3
"""Estimate token count for files, directories, or stdin."""

from __future__ import annotations

import argparse
import json
import os
import sys
from pathlib import Path
from typing import Callable

TokenCounter = Callable[[str], int]

BINARY_CHECK_SIZE = 8192
LARGE_FILE_THRESHOLD = 1_048_576


def make_anthropic_counter() -> TokenCounter:
    from anthropic_tokenizer import count_tokens

    return count_tokens


def make_tiktoken_counter() -> TokenCounter:
    import tiktoken

    enc = tiktoken.encoding_for_model("gpt-4")
    return lambda text: len(enc.encode(text))


TOKENIZERS: dict[str, Callable[[], TokenCounter]] = {
    "anthropic": make_anthropic_counter,
    "tiktoken": make_tiktoken_counter,
}


def resolve_counters(names: list[str]) -> dict[str, TokenCounter]:
    counters: dict[str, TokenCounter] = {}
    for name in names:
        factory = TOKENIZERS.get(name)
        if factory is None:
            sys.exit(
                f"error: unknown tokenizer '{name}'. choices: {list(TOKENIZERS.keys())}"
            )
        try:
            counters[name] = factory()
        except ImportError as e:
            print(
                f"warn: {name} tokenizer unavailable ({e}), skipping", file=sys.stderr
            )
    if not counters:
        sys.exit(
            f"error: no tokenizers available. install one of: {', '.join(TOKENIZERS.keys())}"
        )
    return counters


def collect_files(targets: list[str]) -> list[Path | None]:
    """Resolve targets to file paths. None represents stdin (deduplicated)."""
    result: list[Path | None] = []
    seen_stdin = False
    for target in targets:
        if target == "-":
            if not seen_stdin:
                result.append(None)
                seen_stdin = True
            continue
        p = Path(target)
        if p.is_file():
            result.append(p)
        elif p.is_dir():
            for root, _, files in os.walk(p, followlinks=True):
                for f in sorted(files):
                    result.append(Path(root) / f)
        else:
            print(f"warn: skipping {target} (not found)", file=sys.stderr)
    return result


def read_path(path: Path | None) -> tuple[str, str] | None:
    """Read file content. Returns (display_path, text) or None on skip."""
    if path is None:
        return ("<stdin>", sys.stdin.read())

    try:
        raw = path.read_bytes()
    except OSError as e:
        print(f"warn: cannot read {path}: {e}", file=sys.stderr)
        return None

    if b"\x00" in raw[:BINARY_CHECK_SIZE]:
        print(f"warn: skipping binary file {path}", file=sys.stderr)
        return None

    if len(raw) > LARGE_FILE_THRESHOLD:
        print(f"warn: large file ({len(raw)} bytes): {path}", file=sys.stderr)

    return (str(path), raw.decode("utf-8", errors="replace"))


def count_files(
    files: list[Path | None], counters: dict[str, TokenCounter]
) -> list[dict]:
    results = []
    for f in files:
        content = read_path(f)
        if content is None:
            continue
        display_path, text = content
        if not text:
            entry: dict = {"path": display_path, "tokens": {name: 0 for name in counters}}
        else:
            tokens = {name: counter(text) for name, counter in counters.items()}
            entry = {"path": display_path, "tokens": tokens}
        if f is None:
            entry["content"] = text
        results.append(entry)
    return results


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Estimate token count for files/directories/stdin"
    )
    parser.add_argument(
        "targets", nargs="*", default=["-"], help="files, directories, or - for stdin"
    )
    parser.add_argument(
        "--tokenizer",
        "-t",
        default="anthropic",
        help="comma-separated tokenizers: anthropic,tiktoken (default: anthropic)",
    )
    args = parser.parse_args()

    names = [n.strip() for n in args.tokenizer.split(",")]
    for name in names:
        if name not in TOKENIZERS:
            sys.exit(
                f"error: unknown tokenizer '{name}'. choices: {list(TOKENIZERS.keys())}"
            )
    counters = resolve_counters(names)
    files = collect_files(args.targets)
    results = count_files(files, counters)
    totals = {name: sum(r["tokens"][name] for r in results) for name in counters}

    print(json.dumps({"files": results, "total": totals}))


if __name__ == "__main__":
    main()
