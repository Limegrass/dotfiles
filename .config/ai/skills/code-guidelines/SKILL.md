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
- Declarative artifacts -- code standalone without context of conversation

## Strict Types

Narrow types. No `any`/`object`/`unknown`-equivalent, no untyped maps/collections.
`unknown` at boundaries with type guards for narrowing.
Explicit nullability.
No type casting. Refactor to type guards, pattern matching, or redesign.
Casts bypass compiler guarantees; treat as code smell.
If unavoidable, justify with inline comment.

## Explicit Interfaces

Make misuse hard, not merely avoidable -- encode constraints in types (newtypes, branded types, enums over booleans).
Be explicit at the boundary: bound expensive/unbounded operations (pagination, caps);
declare weak guarantees (eventual consistency, partial results) and failure modes (typed errors, error enums), never implicit.

## Self-Documenting Code

Names and structure self-document. Comments only when code cannot express intent
(magic numbers, external constraints, non-obvious invariants).
Document "why". e.g. why it was chosen, why it works, why it exists,
never about "what" it is as code should be self-descriptive.

- Descriptive names over documentation
  - Err on verbosity. Type names over 1 letter names.
  - Avoid abbreviations. Common words like `ID` are ok, but qualify with type `userId`.
- Extract named/documented functions over commenting
- Function docs: context/rationale good; restating signature bad

### Inline Comments

Only short (1-5 words) inline comments allowed and written on applicable line.
All other comments should be in the docstring for the variable/function/etc,
or refactored out to have a docstring as needed.

```rust
let offset = raw + 10; // legacy protocol header padding
```

```rust
/// * 10 bytes offset is required for the protocol-related bit flags.
/// The flags are...
let offset = raw + 10;
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

## Draft Before Code

Commit message per commit and review description for the set, both drafted before the work. The
draft bounds scope: work it does not describe belongs to a later commit, and the draft never grows
to absorb what the work picked up.

Formats: `commit-message` and `review-description` skills.

## Information Placement

One fact, one home. Route by the question it answers. This file governs what code and its comments
carry; each other artifact is governed by its own skill.

`Code`: what happens. Names and structure carry it; no prose needed.
`Doc comment`: why this shape -- invariants, external constraints, caller obligations,
alternatives that must stay rejected. Readable without diff, history, or review tool.
`Commit message`: why this delta. `commit-message` skill.
`Code review description`: how to review. `review-description` skill.
`Code review comment`: what helps a reviewer understand what the change introduces at these lines
-- the decision behind it, a question about it, where to look first. Sits where the reviewer meets
the code, so they read it against what it describes rather than hunting for it. Ends at merge.

Routing test:

needed while reading current code -> `Doc comment`
needed while bisecting -> `Commit message`
useless after merge, attachable to file:line -> `Code review comment`
useless after merge, spanning change -> `Code review description`

`review-description` routes comment versus description; both review homes end at merge.

No conversation history in any of them -- state conclusions, not the path taken.
Change narration belongs to the message, never to code -- `// now handles empty input` restates
what the diff shows and reads as noise once that diff is history.

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
5. Invoke `self-review-loop` skill -- loop a delegated reviewer until no finding remains

Each phase gates the next. No skipping to step 4, and step 4 is not the end -- unreviewed work is
not finished work.

## Parameterization

No magic constants buried in logic. Functions accept arguments; scripts accept
flags/env vars. If a value could change across environments or use cases,
parameterize it.

## Explicit Arguments

Specify optional parameters. Unspecified = "whatever dependency decides next release":
upstream default change becomes silent behavior change, no diff to review, no test to fail.
Explicit values pin behavior to tested version and make intent auditable.

Covers every implicit default: optional args, builder/constructor options, config keys,
infrastructure resource properties, CLI flags, API request fields.

Omit only when inheriting future change is the intent -- hardened-defaults libraries where
tightened defaults should apply on upgrade. Document omission and what governs it;
undocumented omission reads as oversight.

```rust
// Bad: silent behavior change when library default shifts
let client = Client::builder().build();

// Good: pinned
let client = Client::builder().timeout(SECONDS_5).max_retries(3).build();

// Good: deliberate inheritance
// Cipher suites unset -- inherit hardened defaults as library tightens them.
let client = Client::builder().timeout(SECONDS_5).max_retries(3).build();
```

## White Space

Newlines and whitespace for logical separation between blocks.
