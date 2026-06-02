---
name: token-estimate
description: >
  Estimates token counts on files, directories, or piped text.
  Invoke on "how many tokens", "token count", "context budget", "skill size",
  "estimate tokens", "compare token cost", etc.
---

# Token Estimate

```sh
python3 scripts/estimate.py [targets...] [-t anthropic,tiktoken]
```

- `targets`: file paths, directories (recursive), or `-` for stdin
- `-t`: comma-separated tokenizers (default: `anthropic`)

## Output

JSON with `files` array and `total` object. stdin entries include `content` field.

```sh
# strip content field if unneeded
echo "hello" | python3 scripts/estimate.py | jq 'del(.files[].content)'
```
