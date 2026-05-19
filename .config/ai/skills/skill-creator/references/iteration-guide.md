# Iteration Guide

Diagnosis patterns for skill improvement.

## Signal -> Fix

| Signal                  | Fix                             |
| ----------------------- | ------------------------------- |
| False trigger           | Narrow description              |
| Missed trigger          | Add phrases to description      |
| Wrong output            | Add constraints to body         |
| Too verbose             | Trim, compress                  |
| Unnecessary questions   | Add defaults                    |
| Body too large          | Extract to references/          |
| Over-rigid output       | Add "adapt freely" escape valve |
| Under-structured output | Add skeleton/template           |

## Anti-Patterns

| Problem                              | Fix                             |
| ------------------------------------ | ------------------------------- |
| "When to Use" in body                | Move to description             |
| Domain-specific examples             | `<placeholders>`                |
| Comments on obvious                  | Remove                          |
| Multiple responsibilities            | Split into separate skills      |
| Script logic in prose                | Move to scripts/                |
| ALWAYS/NEVER/MUST overuse            | Add reasoning                   |
| Narrow to test examples              | Generalize                      |
| Fixed skeleton for heuristic skill   | Use principles, not rigid steps |
| Redundant statements across sections | Consolidate                     |
| Reference chains 2+ levels deep      | Flatten to one level            |
| Body exceeds 500 lines               | Extract to references/          |

## Calibration Examples

### Bad: Over-rigid, domain-specific, restates obvious

```markdown
## Rules

- ALWAYS use TypeScript
- NEVER import from relative paths
- You MUST add unit tests for all functions

## When to Use

Use this skill when writing TypeScript code.
```

Problems:

- Bare imperatives without reasoning
- "When to Use" belongs in description, not body
- Domain-locked (TypeScript) instead of generalized

### Good: Reasoned, general, actionable

```markdown
## Rules

- Strict types. `any` hides runtime bugs.
- Edge cases from code analysis, not imagination. Trace to code ref.
- "When to Use" -> description frontmatter, not body.
```

### Bad: Exceeding token budget

```markdown
## Detailed API Reference

[500 lines of API docs inline]
```

Fix: Move to `references/api.md`, link from SKILL.md.

### Bad: Nested reference chains

```
SKILL.md -> references/guide.md -> references/sub/detail.md
```

Fix: Keep references one level deep. `SKILL.md -> references/detail.md`

### Good: Progressive disclosure structure

```
SKILL.md           (concise instructions, <500 lines)
references/
├── api.md         (loaded only when API work needed)
├── examples.md    (loaded only when examples requested)
└── patterns.md    (loaded only when pattern lookup needed)
scripts/
└── validate.sh    (executed, never loaded into context)
```
