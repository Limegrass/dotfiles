---
name: plan-for-correctness
description: >
  Guides implementation planning from a correctness perspective.
  Invoke when delegated to plan changes focusing on edge cases,
  error handling, type safety, and validation.
---

# Planning for Correctness

Analysis and recommendations only. No modifications.

## Analysis

Non-exhaustive. Explore beyond these when context warrants.
For each affected component, identify:

1. **Boundary conditions** -- empty, null, max, negative, concurrent inputs.
   Cite specific fields/params by name.
2. **Error propagation** -- trace each failure path. Does caller see it?
   Distinguish recoverable vs fatal.
3. **Type tightness** -- can invalid states compile? Narrow types prevent bugs
   cheaper than runtime checks.
4. **Invariant preservation** -- pre/post conditions. State transitions that
   must be atomic.
5. **Trust boundaries** -- user input, network responses, file I/O, cross-service calls.
   Validate at boundary, trust internally.

## Red Flags

- Swallowed errors (empty catch, ignored return)
- Assumptions about input shape without validation
- Race conditions on shared mutable state
- Partial failure leaving inconsistent state (no rollback/compensation)
- String typing where enum/union fits

## Scope Boundaries

Deprioritize:
- Startup-only code (fails fast, low blast radius)
- Internal module boundaries with single caller
- Paths already covered by upstream validation

Prioritize: public APIs, data persistence, concurrent access, distributed calls.

## Output

```markdown
### Correctness Analysis

#### Findings
<What's wrong, where (file:line or type), severity>

#### Proposed Changes
<File + code-level changes. Before/after snippets.
Each explains WHY it ensures correct behavior.>

#### Edge Cases Requiring Tests
<Concrete scenarios from analysis. Each traces to a code path.>

#### Trade-offs
<Cost to simplicity or performance. Be specific.>
```

## Calibration

Bad (vague, unanchored):
> "Make sure to handle all edge cases and add proper error handling."

Good (specific, traceable):
> "`processOrder(order)` at OrderService.java:47 assumes `order.items` non-empty.
> Empty list causes NPE at line 52 in `calculateTotal()`.
> Fix: guard clause returning `Result.empty()` before iteration.
> Test: `processOrder(Order.builder().items(List.of()).build())` -> empty result."
