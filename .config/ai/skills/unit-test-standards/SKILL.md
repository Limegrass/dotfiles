---
name: unit-test-standards
description: >
  Unit test quality bar: mocking, coverage, anti-patterns, isolation, parameterization.
  Invoke when writing, reviewing, or refactoring unit tests, or when test code
  needs validation against team standards. Also triggers on "test structure",
  "flaky test", "parameterized test", "test isolation".
---

# Unit Test Standards

Tests document invariants. Each test is a contract.

## Principles

`Explicitness`: readable without tracing shared state or inheritance
`Behavior over implementation`: internal refactors don't break tests
`Tests are specs`: name + body documents a system rule
`Diagnostic failures`: failure message identifies problem without debugging
`Isolation`: each test runs independently, any order, any subset

## Mocking

Test actual logic. Mock minimally.

- Mock non-determinism (time, network, filesystem)
- Mock expensive setup that obscures intent
- Real objects when feasible -- catches integration bugs early
- Setup mostly mock config? Reconsider what you're testing

Over-mocking signal: changing implementation (not behavior) breaks tests.

| Dependency type                   | Default                     |
| --------------------------------- | --------------------------- |
| Pure function / value object      | Real                        |
| Repository / HTTP / filesystem    | Mock                        |
| Clock / random                    | Mock                        |
| Internal collaborator (stateless) | Real unless setup > 5 lines |
| Internal collaborator (stateful)  | Test double                 |

## Test Data

- Inline all data in new files. Explicitness over DRY.
- Follow established patterns in existing files.
- No magic values without explanation.
- Descriptive names: `expired_card` not `card2`.
- Builder/factory for complex objects with many optional fields.

## Parameterized Tests

Use when: same logic, different inputs/expected outputs.

- Each parameter set independently understandable.
- Display name describes scenario, not "case 1".
- Don't parameterize when cases have different assertion shapes.
- Branches in test body -> split into separate tests.

## Assertions

- Multiple asserts OK for one behavior. Split for independent behaviors.
- Specific matchers over size/boolean checks.
- Assert domain meaning, not implementation artifacts.
- Failure message self-explanatory without reading source.

## Coverage

Test all code paths unless test only validates mock wiring.

Skip: generated code, pure delegation, framework config (integration tests cover).

### Test Categories

All applicable when unit has corresponding behavior:

`Happy path`: basic contract fulfilled
`Edge cases`: null, empty, boundary values, off-by-one
`Error paths`: exceptions, fallback behavior, invalid input
`Concurrency`: race conditions, ordering (often integration-level)

### Incidental Behavior

Assert incidental behavior, document as non-contractual.
Future refactors may change unspecified behavior without breaking clients.

## Test Isolation

- No shared mutable state. Each test constructs own state.
- Shared setup only for truly universal needs (logger, test double reset).
- No ordering assumptions. Tests pass in random order.
- No filesystem/env side effects without cleanup.
- Parallelizable by default.

## Traps

`Flaky = bug`: race condition in prod or bad isolation. Fix root cause, not retry.
`Time`: mock clock, never sleep. Sleep = flaky by definition.
`Test-per-method trap`: test per behavior, not per method.
`Assertion style`: use project's existing library. Don't mix in one file.
`Verify vs assert`: mock verification tests wiring. Assert return value or state.
`Exception breadth`: assert type AND message/code. Broad catch hides bugs.
`Data coupling`: shared constant != shared semantics. Inline if meaning differs.

## Anti-Patterns

| Pattern                          | Problem            | Fix                        |
| -------------------------------- | ------------------ | -------------------------- |
| Mirrors implementation           | Breaks on refactor | Assert observable behavior |
| Shared mutable state             | Order-dependent    | Isolate per test           |
| Tests private methods            | Couples internals  | Test through public API    |
| Heavy shared setup               | Hides context      | Inline or explicit helpers |
| Catches broad exception type     | Too broad          | Specific type + message    |
| `assert(result)` / `assert true` | Useless failure    | Specific matcher           |
| Verify mock called, not outcome  | Tests wiring       | Assert result/state        |
| Copy-paste, 1 param differs      | Maintenance cost   | Parameterized test         |
| Test knows implementation order  | Brittle sequencing | Assert set/contains        |
| Catch-then-assert exception      | Hides stack trace  | Framework exception assert |
| Disabled/skipped without ticket  | Forgotten forever  | Link ticket or delete      |
