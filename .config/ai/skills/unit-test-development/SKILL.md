---
name: unit-test-development
description: >
  Write and validate unit tests through iterative loop until all test categories
  covered and standards met. Invoke when writing new tests, adding test coverage,
  or asked to "write tests for", "add tests", "cover this code", "TDD".
  Complements unit-test-standards (knowledge) with active procedure.
---

# Unit Test Development

Write tests. Validate against standards. Iterate until compliant.

## Process

1. Identify unit under test -- read source, list behaviors
2. Map behaviors to test categories
3. Write tests for uncovered categories
4. Validate (invoke `unit-test-standards` skill as checklist)
5. Fix violations
6. Run tests -- confirm pass
7. Repeat 4-6 until stable

## Phase 1: Behavior Inventory

Read the unit under test. List distinct behaviors:

```
Unit: OrderService.submit()
Behaviors:
- Submits valid order successfully
- Rejects empty cart
- Applies discount when eligible
- Handles payment gateway timeout
- Validates shipping address
```

Each behavior gets at least one test.
Complex behaviors may need multiple (happy + edge).

## Phase 2: Category Mapping

For each behavior, check applicable categories:

```
[ ] Happy path -- primary contract verified?
[ ] Edge cases -- boundary values covered?
[ ] Error paths -- failure modes verified?
[ ] Concurrency -- shared-state access tested? [if: applicable, else N/A]
```

Missing check = write test.
Mark N/A explicitly -- silence hides gaps.

## Phase 3: Write

Write tests for gaps identified in Phase 2.
Follow project conventions (existing test files = style guide).

## Phase 4: Validate

Invoke `unit-test-standards` skill. Use as checklist against each written test.
Fix violations found. No new criteria here -- standards skill is source of truth.

## Phase 5: Iterate

```
validate -> violations? --yes--> fix -> re-validate
                |
                no
                |
                v
          run tests -> pass? --no--> fix -> re-run
                |
                yes
                |
                v
              DONE
```

Termination criteria:

- All applicable categories have tests
- No standard violations remain
- Tests pass

## Rules

- Never pass a cycle with uncovered applicable category
- Run tests each iteration -- green required before done
- When modifying existing tests: preserve intent, improve quality
- Existing tests: validate + report first. Don't rewrite without ask.
