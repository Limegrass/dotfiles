---
name: plan-for-correctness
description: >
  Plan implementation focusing on correctness: edge cases, error
  handling, type safety, validation, invariants. Invoke when
  delegated to analyze changes from correctness perspective.
---

# Planning for Correctness

Produce findings and recommendations, not implementations.

## Analysis

For each affected component, identify:

1. `Boundary conditions`: empty, null, max, negative, zero, off-by-one.
   Cite specific fields/params. Include closed vs open ranges (< vs <=).
2. `Error propagation`: trace each failure path. Caller sees it?
   Recoverable vs fatal. Checked vs unchecked.
3. `Type tightness`: can invalid states compile? Narrow types prevent bugs
   cheaper than runtime checks. Prefer sum types over boolean flags.
4. `Invariant preservation`: pre/post conditions. Atomic state transitions.
   Document implicit invariants that code assumes but doesn't enforce.
5. `Trust boundaries`: user input, network responses, file I/O, cross-service.
   Validate at boundary, trust internally.
6. `Idempotency`: retryable operations produce same result on re-execution.
   Side effects guarded by deduplication or conditional writes.
7. `Concurrency safety`: shared mutable state, check-then-act (TOCTOU),
   visibility across threads, non-atomic compound operations.
   Locks, CAS, or immutability -- pick one explicitly.

## Traps

- Validation at boundary, trust internally. Double-validation = bugs in two places.
- "Works in tests" != correct. Tests skip: concurrency, partial failure, resource exhaustion.
- Swallowed errors (empty catch, ignored return) hide failures until cascade.
- Partial failure leaving inconsistent state needs rollback/compensation -- not just logging.
- String typing where enum/union fits lets invalid states exist at compile time.
- Check-then-act without atomicity: "if exists, read" = TOCTOU race.
- Optional/nullable return without forcing caller to handle absence -- NPE deferred, not prevented.
- Defensive copy missing on mutable inputs: caller mutates after passing, receiver sees corruption.

## Scope

Deprioritize: startup-only code, internal single-caller boundaries, paths covered upstream.

Prioritize: public APIs, data persistence, concurrent access, distributed calls.

## Output

```markdown
### Correctness Analysis

#### Findings
<What's wrong, where (file:line or type), severity>

#### Proposed Changes
<File + code-level changes. Before/after snippets.>

#### Edge Cases Requiring Tests
<Concrete scenarios. Each traces to a code path.>

#### Trade-offs
<Cost to simplicity or performance.>
```

## Calibration

Bad:
> "Make sure to handle all edge cases and add proper error handling."

Good:
> "`processOrder(order)` at OrderService.java:47 assumes `order.items` non-empty.
> Empty list causes NPE at line 52 in `calculateTotal()`.
> Fix: guard clause returning `Result.empty()` before iteration.
> Test: `processOrder(Order.builder().items(List.of()).build())` -> empty result."
