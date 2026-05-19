# Script Patterns

Agentic script design for skills. Load when bundling scripts into scripts/.

## When to Bundle

- Same code rewritten >2 times across invocations
- Logic is deterministic and testable
- Execution is cheaper than loading into context
- Agent independently reinvents similar helper each run

## Self-Contained Dependencies

Scripts declare own deps inline. No separate install step needed.

### Python (PEP 723 + uv)

```python
# /// script
# dependencies = [
#   "beautifulsoup4>=4.12,<5",
# ]
# requires-python = ">=3.11"
# ///
from bs4 import BeautifulSoup
# ...
```

Run: `uv run scripts/extract.py`

### Deno (npm: specifiers)

```typescript
#!/usr/bin/env -S deno run
import * as cheerio from "npm:cheerio@1.0.0";
// ...
```

Run: `deno run scripts/extract.ts`

### Ruby (bundler/inline)

```ruby
require 'bundler/inline'
gemfile do
  source 'https://rubygems.org'
  gem 'nokogiri', '~> 1.16'
end
```

Run: `ruby scripts/extract.rb`

## Agentic Interface Design

### Hard Requirements

- **No interactive prompts**. Agents operate non-interactive shells.
  Accept input via flags, env vars, or stdin. Blocking on TTY = hang forever.
- **Pin versions**. `npx eslint@9.0.0`, not `npx eslint`.

### Interface Discovery

`--help` is how agent learns script interface. Include:

- Brief description
- Available flags with types/defaults
- Usage examples

```
Usage: scripts/process.py [OPTIONS] INPUT_FILE

Process input data and produce a summary report.

Options:
  --format FORMAT    Output format: json, csv, table (default: json)
  --output FILE      Write output to FILE instead of stdout
  --verbose          Print progress to stderr

Examples:
  scripts/process.py data.csv
  scripts/process.py --format csv --output report.csv data.csv
```

### Error Messages

Shape agent's next attempt. Include:

- What went wrong
- What was expected
- What to try

```
Error: --format must be one of: json, csv, table.
       Received: "xml"
```

### Output Design

- Structured formats (JSON, CSV) over free-form text
- Data to stdout, diagnostics to stderr
- Predictable output size (agent harnesses may truncate >10-30K chars)
- Consider `--offset` / pagination for large output

### Safety Properties

- **Idempotent**: "create if not exists" over "create and fail on duplicate"
- **Input validation**: reject ambiguous input with clear error. Use enums/closed sets.
- **Dry-run**: `--dry-run` flag for destructive/stateful operations
- **Meaningful exit codes**: distinct codes for different failure types, documented in --help
- **Safe defaults**: destructive ops require `--confirm`/`--force`

## One-Off Commands (No scripts/ Needed)

When existing packages do the job, reference directly:

| Runtime | Tool | Example                                   |
| ------- | ---- | ----------------------------------------- |
| Python  | uvx  | `uvx ruff@0.8.0 check .`                  |
| Python  | pipx | `pipx run 'black==24.10.0' .`             |
| Node    | npx  | `npx eslint@9 --fix .`                    |
| Bun     | bunx | `bunx eslint@9 --fix .`                   |
| Deno    | deno | `deno run npm:create-vite@6 app`          |
| Go      | go   | `go run golang.org/x/tools/...@v0.28.0 .` |

State prerequisites in SKILL.md or `compatibility` frontmatter field.
