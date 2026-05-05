---
name: spec-driven-development
description: >
  Produces a spec document before implementing code changes. Documents current
  state (code refs, types, example data), desired state (before/after delta),
  affected components, and edge cases. Scales depth to change complexity.
  Invoke when asked to: write a spec, spec out a change, plan a feature, define
  requirements, design an approach, or before implementing any feature/fix/refactor.
---

# Spec-Driven Development

Spec before code. Implementation follows spec as source of truth.
Spec depth scales to change complexity -- not every change needs full template.

## Process

1. Gauge complexity. Pick spec depth (see Scaling below).
2. Understand types/schemas involved. Read definitions, search codebase.
   If types unavailable, AskUser before proceeding.
3. Research current state: read code, trace paths, query data if accessible.
4. Write spec to file immediately. TODOs acceptable -- draft > blocking.
5. Mark unknowns `[TODO: user to provide]`. AskUser for critical values.
6. Present spec for review. Proceed once confirmed, or immediately if user
   requested both spec + implementation in same prompt.

## Scaling

Not all changes deserve full spec. Match depth to risk:

| Complexity | Signal                                           | Spec Depth                                                |
| ---------- | ------------------------------------------------ | --------------------------------------------------------- |
| Trivial    | Single file, obvious transform, no edge cases    | Inline in plan doc (3-5 lines: what, why, where)          |
| Low        | Few files, clear delta, <3 edge cases            | Light spec (Problem + Delta + Affected Components)        |
| Medium     | Cross-component, state changes, new validation   | Standard spec (full template minus inapplicable sections) |
| High       | New subsystem, multi-entity, API contract change | Full spec + type definitions + data examples              |

When uncertain, start with standard. Trim after.

Trivial example (inline in plan doc):

> What: Rename `getUserName` -> `getDisplayName` in `utils/format.ts`
> Why: Aligns with naming convention from <ticket>
> Where: Single call site in `components/Header.tsx` L42

Low example (light spec):

> ## Problem Statement
>
> Event handler silently drops messages when payload exceeds 256KB.
>
> ## Delta
>
> | Aspect            | Before           | After                    | Why                                    |
> | ----------------- | ---------------- | ------------------------ | -------------------------------------- |
> | Oversized payload | Dropped silently | Routed to DLQ with alarm | Data loss unacceptable for audit trail |
>
> ## Affected Components
>
> | Component      | Change Type | Risk | Reference                          |
> | -------------- | ----------- | ---- | ---------------------------------- |
> | EventProcessor | modify      | med  | [event_processor.ts L80-L95](link) |
> | DLQ config     | new         | low  | N/A                                |

## Output

File: `spec-{ticket-id}.md` or `spec-{feature-slug}.md`
Location: user's preferred docs location, or alongside plan documents.

## Template

Sections are menu. Omit inapplicable. Mark conditional sections with `[if: ...]`.

```markdown
# Spec: <title>

Ticket: <link or N/A>
Date: <ISO date>

## Problem Statement

What needs to change. Why. One paragraph.

## Types & Schema [if: change involves typed data]

Key types governing this change. Include definition or permalink.

| Type       | Definition                | Role in Change      |
| ---------- | ------------------------- | ------------------- |
| <TypeName> | [<File> L#-L#](permalink) | <how it's affected> |

## Current State

### Behavior

How system works today. Invocation path if complex.
Focus on WHY current behavior exists, not just WHAT it does.

### Code References

| Component | File                      | Role                      |
| --------- | ------------------------- | ------------------------- |
| <name>    | [<File> L#-L#](permalink) | <purpose in current flow> |

### Evidence [if: observable data exists]

Actual data showing current behavior. Format matches domain
(JSON, SQL result, CLI output, rendered UI, log line, etc.)
```

<actual system output>
```

## Desired State

### Behavior

How system should work after change. What invariant it establishes.

### Delta

| Aspect                          | Before    | After     | Why                 |
| ------------------------------- | --------- | --------- | ------------------- |
| <field, behavior, or structure> | <current> | <desired> | <reason for change> |

### Evidence (After) [if: transformation has concrete output]

Same shape as current, showing result.

```
<expected output>
```

## Affected Components

| Component | Change Type              | Risk           | Reference           |
| --------- | ------------------------ | -------------- | ------------------- |
| <name>    | <new/modify/remove/test> | <low/med/high> | [<File>](permalink) |

## Edge Cases

Discovered through: code path analysis, input boundaries, failure modes.
Each traces to conditional branch, boundary, or failure in existing code.

### <description>

Source: [<File> L#](permalink) -- <why this edge exists>

Options:

- A: <behavior>
- B: <behavior>

Chosen: [TODO: user to specify]

## Out of Scope

What this change explicitly does NOT do. Prevents scope creep.

## Risks & Rollback [if: production-facing change]

| Risk                  | Likelihood     | Mitigation      |
| --------------------- | -------------- | --------------- |
| <what could go wrong> | <low/med/high> | <how to handle> |

Rollback: <revert strategy or "standard deploy rollback">

```

## Rules

- Under types/schemas before proposing changes.
- Current State from source code. Real permalinks, not invented refs.
- Evidence from actual system output -- query APIs, read tests, ask user.
- Edge cases from code analysis, not imagination. Each traces to code ref.
- Delta table: include WHY column. Transformation without reason is incomplete.
- After approval, spec = source of truth for implementation.
```
