---
name: web-fetch
description: >
  Fetch and extract web page content for context-efficient consumption.
  Use when agent needs info from a URL, user says "fetch this page",
  "read this doc", "research this link", "what does this page say".
---

# Web Fetch

Fetch -> extract -> delegate -> consume.

## Process

1. `scripts/fetch.sh <url>`
   stdout: path to saved file. On failure: report stderr to user, stop.

2. `scripts/extract.sh <path> [--selector SEL]`
   stdout: extracted text. On exit 2: retry `--selector body`.

3. Delegate text (extracted, or raw file if step 2 failed) to readonly sub-agent:
   - Forward your communication/markdown rules
   - Code, commands, blockquotes: VERBATIM
   - Preserve structure (headings, lists, links)
   - Source URL at top of output
   - Research question or "summarize for user"

4. Write delegate output to `{WEBFETCH_DIR}/{domain}-...-summary.md`.

5. Use delegate output only. Raw text never enters main context.

## Traps

- htmlq/pandoc missing: scripts degrade (raw HTML / stripped tags).
  Pipeline works, quality drops. `cargo install htmlq` for best results.
- Boilerplate in output: retry `--selector` targeting content container.
  Common: `.post-content`, `article`, `#content`, `main`.
- SPA/JS-rendered: extraction yields <100 chars or only script tags.
  Report "requires JavaScript rendering." Suggest user paste.
- Network block: curl rejected or auth required. Report; suggest user paste.
- Large page: if extracted text >100KB, tell delegate to focus on
  specific sections relevant to research question.
- Skipping delegate: never. Full text in main context wastes tokens.
