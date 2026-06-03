---
name: code-guidelines
description: >
  Guidelines for all code. Required if code may be produced.
  tags: implement, code, fix bug, refactor, add feature, update, modify, code review
---

# Code Standards

Language supplements: `references/`

## Rules

- No code without domain understanding (can explain why current approach exists)
- No implementation without spec/plan for non-trivial work (>1hr or multi-file)
- Tests added or changed before implementation; edge cases understood and handled.
- Types encode constraints—push validation to compile time; runtime validation at external data boundaries
- Atomic single-purpose commits
- Readability and extensibility default; performance on request with trade-off disclosure

## Strict Types

Narrow types. No `any`/`object`/`unknown`-equivalent, no untyped maps/collections.
`unknown` at boundaries with type guards for narrowing.
Explicit nullability.
No type casting. Refactor to type guards, pattern matching, or redesign.
Casts bypass compiler guarantees; treat as code smell.
If unavoidable, justify with inline comment.

## Self-Documenting Code

Names and structure self-document. Comments only when code cannot express intent
(magic numbers, external constraints, non-obvious invariants).

- Descriptive names over documentation
- Extract to named function instead of comment
- Function docs: context/rationale good; restating signature bad

### Inline Comments

Write inline comment on applicable line. No long inline comments -- refactor to
function with docs if explanation requires vertical space.

```rust
let offset = raw + 10; // legacy protocol header padding
```

## Error Handling

Error messages: what happened -> expected -> what to do.

```rust
// Good: "Failed to connect to database at localhost:5432. Expected running. Start: docker-compose up db"
// Bad: "Connection failed"
```

## Root-Cause Analysis

Fix general class, not immediate symptom.
Symptom -> why? -> fix pattern -> check sibling cases.
Specific fix = future regression. General fix = durable system.

## Commit Hygiene

1 change type per commit. Conventional format. Prioritize: refactors/fixes before features.

```
# bad: fix(auth): null check and add session timeout config
# good: two commits—fix(auth): null check | feat(auth): session timeout
```

## Universal Style

- Test names: `action_condition_expected`. Mock at I/O boundaries only. Property tests for pure functions.
- No linter overrides without justification

## Language Fallback

Languages without supplement: use strongest type system features, prefer immutable
data, follow community canonical formatter/linter.

## Implementation

Order: understand -> plan -> prove -> build.

1. Invoke `domain-documentation` skill -- research domain before implementation
2. Invoke `spec-driven-development` skill -- spec before code
3. Invoke `unit-test-development` skill -- tests before implementation
4. Implement

Each phase gates the next. No skipping to step 4.

## Parameterization

No magic constants buried in logic. Functions accept arguments; scripts accept
flags/env vars. If a value could change across environments or use cases,
parameterize it.

## White Space

Newlines and whitespace for logical separation between blocks.
