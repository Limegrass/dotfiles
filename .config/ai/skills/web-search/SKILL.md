---
name: web-search
description: >
  Search the web and extract results. Use when agent needs to research
  a topic, find documentation, look up errors, or user says "search for",
  "look up", "find info about", "what is".
  Distinct from web-fetch (specific URL) -- this discovers URLs.
---

# Web Search

Search -> extract results -> optionally follow links.

## Engine

DuckDuckGo `/html/` endpoint. Only reliable curl-accessible search engine.

URL: `https://duckduckgo.com/html/?q=${encoded}`

Rate limit: captchas on burst. HTTP 202 with puzzle. Duration unknown.
Throttle check: `rg -qi 'anomaly-modal|captcha' <raw-file>` -- match = stop.

DDG redirects: result links contain `//duckduckgo.com/l/?uddg=...`.
Actual URL after `uddg=` param.

DDG-specific operators:
- `~"phrase"` -- semantic similarity (experimental)
- `+term` -- boost (not supported elsewhere)

## Process

1. Construct query:

   Rate-limited. Optimize search quality.

   - 3-5 discriminating keywords. No sentences.
   - Quote multi-word identifiers: `"cold start"` not `cold start`.
   - `site:` if domain known.
   - `-site:pinterest.com -site:quora.com` to exclude noise.
   - Specificity > breadth.
   - Errors: quote exact message + language/framework.
   - Comparison: `X vs Y`, quote proper nouns.

   Standard operators:
   - `"exact phrase"` -- exact match
   - `-term` -- exclude
   - `site:` / `-site:` -- domain filter
   - `filetype:pdf` -- file type (pdf, doc(x), xls(x), ppt(x), html)
   - `intitle:keyword` / `inurl:keyword` -- title/URL filter

2. Encode + fetch:
   ```sh
   encoded=$(printf '%s' "query here" | jq -sRr @uri)
   ```
   Invoke web-fetch on engine URL with `${encoded}` substituted.

3. Throttle check (see Engine section). If throttled, stop.

4. Delegate parses results. Present top or select URLs for deeper fetch.

## Traps

- Too specific: simplify to key terms.
