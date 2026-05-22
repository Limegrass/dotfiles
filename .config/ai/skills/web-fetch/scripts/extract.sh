#!/bin/sh
set -eu

usage() {
    cat <<EOF >&2
Usage: extract.sh <file> [--selector SELECTOR]

Extract meaningful content from fetched web content.
HTML: uses htmlq for CSS selection + pandoc for markdown conversion.
Non-HTML: passes through with whitespace cleanup.

Cascading selector strategy (HTML only): user-provided > article > main > common classes > body.

Input: path to file (from fetch.sh output)
Output: markdown or text (stdout)
Side effect: saves extracted content to ${WEBFETCH_DIR}/ for corroboration

Exit codes:
  0  success
  1  read error
  2  empty extraction

Options:
  --selector SEL  CSS selector to use (skips cascading, HTML only)
  -h, --help      Show this help

Examples:
  extract.sh /tmp/web-research/docs.python.org-20240101-120000-raw
  extract.sh /tmp/web-research/blog.com-20240101-120000-raw --selector '.post-body'
EOF
    exit 0
}

# Configuration (override via environment)
WEBFETCH_DIR="${WEBFETCH_DIR:-/tmp/web-research}"

HAS_HTMLQ=$(command -v htmlq >/dev/null 2>&1 && echo 1 || echo 0)
HAS_PANDOC=$(command -v pandoc >/dev/null 2>&1 && echo 1 || echo 0)

try_selector() {
    file="$1"
    selector="$2"
    result=$(htmlq "$selector" < "$file" 2>/dev/null || true)
    trimmed=$(echo "$result" | sed '/^[[:space:]]*$/d')
    if [ -n "$trimmed" ]; then
        echo "$result"
        return 0
    fi
    return 1
}

html_to_markdown() {
    # Cleanup pipeline (mechanical only, no content removal):
    # 1. sed: strip pandoc attribute noise + trim trailing whitespace
    # 2. cat -s: squeeze consecutive blank lines
    if [ "$HAS_PANDOC" = "1" ]; then
        pandoc -f html -t markdown --reference-links 2>/dev/null \
            | sed -e 's/ {[^}]*}//g' -e 's/[[:space:]]*$//' \
            | cat -s
    else
        sed -e 's/<[^>]*>//g' -e 's/[[:space:]]*$//' \
            | cat -s
    fi
}

# Returns: sets is_html=0|1
detect_content_type() {
    is_html=0
    meta_file="$(echo "$1" | sed 's/-raw$/-meta.txt/')"
    if [ -f "$meta_file" ]; then
        grep -qi 'content-type:.*text/html\|content-type:.*application/xhtml' "$meta_file" && is_html=1
    else
        grep -qiE '<html|<!doctype|<head' "$1" && is_html=1
    fi
}

# Returns: sets meta="" or meta="title: ...\n..."
# Single htmlq call for all metadata (reduces DOM parsing from 4x to 1x)
extract_metadata() {
    meta=""
    [ "$HAS_HTMLQ" = "0" ] && return 0

    # Extract title + meta tags in one pass via combined selector
    raw_meta=$(htmlq 'title, meta[name="description"], meta[property="article:published_time"], time[datetime]' < "$1" 2>/dev/null || true)
    [ -z "$raw_meta" ] && return 0

    title=$(echo "$raw_meta" | htmlq -t 'title' 2>/dev/null | head -1)
    desc=$(echo "$raw_meta" | htmlq --attribute content 'meta[name="description"]' 2>/dev/null | head -1)
    pub_date=$(echo "$raw_meta" | htmlq --attribute content 'meta[property="article:published_time"]' 2>/dev/null | head -1)
    [ -z "$pub_date" ] && pub_date=$(echo "$raw_meta" | htmlq --attribute datetime 'time' 2>/dev/null | head -1)

    [ -n "$title" ] && meta="title: ${title}"
    [ -n "$desc" ] && meta="${meta:+$meta
}description: ${desc}"
    [ -n "$pub_date" ] && meta="${meta:+$meta
}date: ${pub_date}"
    [ -n "$meta" ] && meta="${meta}
---"
}

extract_html() {
    html_file="$1"
    user_selector="$2"

    # No htmlq: return full file content
    if [ "$HAS_HTMLQ" = "0" ]; then
        echo "warn: htmlq not found, passing raw HTML" >&2
        cat "$html_file"
        return 0
    fi

    html=""

    if [ -n "$user_selector" ]; then
        html=$(try_selector "$html_file" "$user_selector") || true
    fi

    # Cascading selectors
    if [ -z "$html" ]; then
        for sel in \
            "article" \
            "main" \
            ".content, .post-content, #content, .markdown-body, .entry-content"; do
            html=$(try_selector "$html_file" "$sel") || true
            [ -n "$html" ] && break
        done
    fi

    # Fallback: body minus noise elements
    if [ -z "$html" ]; then
        html=$(htmlq 'body' \
            --remove-nodes 'script, style, nav, header, footer, aside, .sidebar, .menu, .ad, .advertisement' \
            < "$html_file" 2>/dev/null || true)
    fi

    echo "$html"
}

persist_output() {
    mkdir -p "$WEBFETCH_DIR"
    base=$(basename "$1" -raw)
    extracted_file="${WEBFETCH_DIR}/${base}-extracted.txt"
    echo "$2" > "$extracted_file"
    echo "saved: $extracted_file" >&2
}

main() {
    html_file=""
    user_selector=""

    while [ $# -gt 0 ]; do
        case "$1" in
            -h|--help) usage ;;
            --selector)
                [ -z "${2:-}" ] && { echo "error: --selector requires a value" >&2; exit 1; }
                user_selector="$2"; shift 2
                ;;
            *) html_file="$1"; shift ;;
        esac
    done

    [ -z "$html_file" ] && { echo "error: file path required. Run with --help for usage." >&2; exit 1; }
    [ ! -f "$html_file" ] && { echo "error: file not found: $html_file" >&2; exit 1; }

    detect_content_type "$html_file"

    meta=""
    if [ "$is_html" = "1" ]; then
        extract_metadata "$html_file"
        html=$(extract_html "$html_file" "$user_selector")
        extracted=$(echo "$html" | html_to_markdown)
    else
        extracted=$(sed 's/[[:space:]]*$//' < "$html_file" | cat -s)
    fi

    trimmed=$(echo "$extracted" | sed '/^[[:space:]]*$/d')
    if [ -z "$trimmed" ]; then
        echo "error: no content extracted from $html_file" >&2
        echo "  try: provide explicit --selector for this page's content container" >&2
        exit 2
    fi

    # Prepend metadata if available
    if [ -n "$meta" ]; then
        extracted="${meta}
${extracted}"
    fi

    persist_output "$html_file" "$extracted"
    echo "$extracted"
}

main "$@"
