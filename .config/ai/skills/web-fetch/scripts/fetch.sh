#!/bin/sh
set -eu

# Configuration (override via environment)
WEBFETCH_DIR="${WEBFETCH_DIR:-/tmp/web-research}"
WEBFETCH_TIMEOUT="${WEBFETCH_TIMEOUT:-15}"
WEBFETCH_MAX_REDIRS="${WEBFETCH_MAX_REDIRS:-5}"
WEBFETCH_USER_AGENT="${WEBFETCH_USER_AGENT:-Mozilla/5.0 (compatible)}"
WEBFETCH_MAX_SIZE="${WEBFETCH_MAX_SIZE:-10485760}" # 10MB default

usage() {
    cat <<EOF >&2
Usage: fetch.sh <url>

Fetch URL content via curl. Save response + metadata to ${WEBFETCH_DIR}/.

Output: file path to saved content (stdout), response metadata (stderr)
Persists: raw content, response headers, metadata summary

Exit codes:
  0  success
  1  network/HTTP error

Options:
  -h, --help    Show this help

Examples:
  fetch.sh https://docs.python.org/3/library/asyncio.html
  fetch.sh https://api.example.com/data.json
EOF
    exit 0
}

main() {
    url="${1:-}"

    [ "$url" = "-h" ] || [ "$url" = "--help" ] && usage
    [ -z "$url" ] && { echo "error: url required. Run with --help for usage." >&2; exit 1; }

    # Scope: web only. Blocks file://, ftp://, dict://, gopher:// etc.
    case "$url" in
        http://*|https://*) ;;
        *) echo "error: only http/https URLs supported" >&2; exit 1 ;;
    esac

    domain=$(echo "$url" | sed -E 's|https?://([^/:@]+).*|\1|' | tr -cd 'a-zA-Z0-9.-')
    [ -z "$domain" ] && domain="unknown"
    timestamp=$(date +%Y%m%d-%H%M%S)

    mkdir -p "$WEBFETCH_DIR"

    prefix="${WEBFETCH_DIR}/${domain}-${timestamp}-$$"
    raw_file="${prefix}-raw"
    headers_file="${prefix}-headers.txt"
    meta_file="${prefix}-meta.txt"

    response=$(curl -sL \
        --max-time "$WEBFETCH_TIMEOUT" \
        --max-redirs "$WEBFETCH_MAX_REDIRS" \
        --max-filesize "$WEBFETCH_MAX_SIZE" \
        -A "$WEBFETCH_USER_AGENT" \
        -D "$headers_file" \
        -o "$raw_file" \
        -w '%{http_code}\n%{content_type}\n%{size_download}\n%{url_effective}\n%{num_redirects}' \
        "$url") || {
        echo "error: network failure fetching $url" >&2
        echo "  expected: successful HTTP response" >&2
        echo "  try: verify URL is reachable with curl" >&2
        # Keep partial artifacts for debugging
        exit 1
    }

    status_code=$(echo "$response" | sed -n '1p')
    content_type=$(echo "$response" | sed -n '2p')
    size_download=$(echo "$response" | sed -n '3p')
    effective_url=$(echo "$response" | sed -n '4p')
    num_redirects=$(echo "$response" | sed -n '5p')

    # Persist metadata to file
    cat > "$meta_file" <<EOF
url: $url
effective-url: $effective_url
status: $status_code
content-type: $content_type
size: $size_download
redirects: $num_redirects
raw: $raw_file
headers: $headers_file
EOF

    # Report on stderr for agent visibility
    cat "$meta_file" >&2

    if [ "$status_code" -ge 400 ]; then
        echo "error: HTTP $status_code for $url" >&2
        echo "  expected: 2xx/3xx response" >&2
        echo "  try: check URL in browser, may require auth" >&2
        # Keep error page for debugging
        exit 1
    fi

    # Note: empty body is valid (HTTP 204/304). Report but don't fail.
    if [ ! -s "$raw_file" ]; then
        echo "warn: empty response body (may be 204/304)" >&2
    fi

    echo "$raw_file"
}

main "$@"
