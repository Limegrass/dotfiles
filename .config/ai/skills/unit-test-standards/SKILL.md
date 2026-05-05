---
name: unit-test-standards
description: >
  Unit test quality bar: mocking, coverage, anti-patterns.
  Invoke when writing, reviewing, or refactoring unit tests,
  or when test code needs validation against team standards.
---

# Unit Test Standards

Tests document invariants. Each test is a contract.

## Principles

1. **Explicitness** -- test readable without tracing shared state or inheritance
2. **Behavior over implementation** -- internal refactors don't break tests
3. **Tests are specs** -- name + body documents a system rule
4. **Diagnostic failures** -- failure message identifies problem without debugging

## Mocking

Test actual logic. Mock minimally to keep test strong.

- Mock non-determinism (time, network, filesystem)
- Mock expensive setup that obscures intent
- Real objects when feasible -- catches integration bugs early
- Setup mostly mock config? Reconsider what you're testing

Signal of over-mocking: changing implementation (not behavior) breaks tests.

| Dependency type                   | Default                     |
| --------------------------------- | --------------------------- |
| Pure function / value object      | Real                        |
| Repository / HTTP / filesystem    | Mock                        |
| Clock / random                    | Mock                        |
| Internal collaborator (stateless) | Real unless setup > 5 lines |
| Internal collaborator (stateful)  | Test double                 |

## Test Data

- New files: inline all data. Explicitness over DRY.
- Existing files: follow established patterns.
- No magic values without explanation.

## Assertions

Multiple asserts OK for one logical behavior.
Split when asserting independent behaviors.

## Coverage

Test all code unless test only validates mock wiring.

Skip:

- Generated code (Lombok, protobuf)
- Pure delegation (`return delegate.call(x)`)
- Framework config (annotations, DI) -- integration tests cover these

### Incidental vs specified behavior

When asserting incidental behavior (not a specified contract, just current implementation):

```
// Incidental: not specified behavior. Returns empty list but could throw NotFound.
assertEquals(List.of(), service.getOrders(unknownUserId));
```

Unnecessary if source already distinguishes specified from incidental.

## Anti-Patterns

| Pattern                         | Problem              | Fix                        |
| ------------------------------- | -------------------- | -------------------------- |
| Mirrors implementation          | Breaks on refactor   | Assert observable behavior |
| Shared mutable state            | Order-dependent      | Isolate per test           |
| Tests private methods           | Couples to internals | Test through public API    |
| Heavy `@Before`                 | Hides context        | Inline or explicit helpers |
| `assertThrows(Exception.class)` | Too broad            | Specific type + message    |
| `assertTrue(result)`            | Useless failure msg  | `assertEquals` or matchers |
| Verify mock called, not outcome | Tests wiring         | Assert result/state        |
| Copy-paste, 1 param differs     | Maintenance cost     | Parameterized test         |
