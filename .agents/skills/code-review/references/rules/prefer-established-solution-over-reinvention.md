# Prefer an Established Solution over Reinvention

A change whose purpose is to build general-purpose functionality a mature, widely-adopted library
already solves gets the library named instead.

## Why

A hand-rolled reimplementation re-introduces edge cases the library has already hardened --
concurrency and thread-safety, eviction correctness, backoff jitter, format-spec compliance -- and
becomes unowned code the team must debug and maintain forever.

## Evidence

Only added or changed lines implementing the non-trivial core of the capability count -- the eviction
policy, the retry/backoff loop, the token-bucket accounting, the hand-written double's behavior. A
reimplementation the diff merely references but does not add is not a finding.

## Intent gate

Suggest a library only where building this capability is what the change sets out to do:

- the commit message states the goal (`feat: add in-memory caching`, `implement request retry`,
  `add rate limiting`), or
- the dominant added content of the diff IS the capability's core -- a new `LruCache` class, a new
  retry helper, a new token bucket.

A capability incidental to a change with a different purpose is not a finding: a one-line `Map` lookup
added inside a feature, a single `sleep`-then-retry inside a bug fix. The author did not set out to
build a cache or a retry framework, so a "use library X" comment is off-target.

## Flag

Hand-rolled reimplementation of a solved, general-purpose capability for which a mature,
widely-adopted library exists. The categories below illustrate; each named library is an example, not
the only acceptable one. Apply the general test -- a mature library already solves this exact
capability -- rather than membership in this list, and map the suggestion to the file's language.

- In-memory cache with eviction, TTL, or size bounds (LRU/LFU maps, manual expiry) -> Caffeine or
  Guava `Cache` (JVM), `cachetools` (Python), `lru-cache` (JS/TS), `moka` (Rust).
- Retry with backoff or jitter, circuit breaker, or bulkhead -> Failsafe or Resilience4j (JVM),
  `tenacity` (Python), `p-retry` (JS/TS), a `backoff` crate (Rust).
- Rate limiting -- token bucket or leaky bucket.
- Connection or object pooling.
- Hand-written parsing or serialization of a standard format -- JSON, YAML, CSV, XML, date/time ->
  Jackson or Gson (JVM), `pydantic` / `csv` / `dateutil` (Python), `serde` (Rust), the platform format
  library rather than a bespoke tokenizer.
- Command-line argument parsing -> picocli (JVM), `argparse` (Python), `clap` (Rust), `cobra` (Go),
  `yargs` or `commander` (JS/TS).
- General collection or functional utilities duplicating Guava, Apache Commons, `lodash`, or
  `itertools`.
- Test doubles -- under the stricter gate below.

## Remedy

Name a specific library only where confident it is the de-facto standard for that capability in that
language. Otherwise recommend "a mature <capability> library" without inventing a name. Where no
established library clearly covers the capability, say nothing.

## Trade-offs

The author owns the decision; every finding gives both sides.

- Benefit: the library handles edge cases and concurrency the hand-rolled version has not proven, is
  battle-tested and maintained upstream, and removes code the team would otherwise own.
- Cost: a new dependency adds build weight, transitive dependencies, and supply-chain surface, may
  require vetting or approval, and carries migration and learning effort.

## Test doubles

In test code the only flaggable category is a hand-written test double: a mock, stub, spy, or fake
class or object standing in for a real collaborator. Recommend the language's standard mocking
framework -- Mockito (JVM), `unittest.mock` or `pytest-mock` (Python), `jest` or `vitest` mocks or
`ts-mockito` (JS/TS), `mockall` (Rust), `gomock` (Go).

Stricter gate: flag only where the change's purpose is to introduce mocking of a collaborator the test
previously exercised for real -- evidenced by the diff removing real construction or wiring of that
collaborator and adding hand-written double behavior in its place, and/or a commit message describing
a move to mocked dependencies.

Manual doubles in a change whose purpose is adding new test coverage -- a `test:` commit adding tests
that use hand-written doubles -- are not a finding. A manual double is a legitimate choice; only the
deliberate migration from real to mocked dependencies warrants suggesting a framework.

## Do NOT flag

- Code that already uses the library -- wrapping or configuring Caffeine, calling Mockito. It
  reinvents nothing.
- A trivial or one-off helper too small for a library to meaningfully replace: a plain `Map` used as a
  lookup, a single retry, a two-line string split. The reimplementation must be substantial enough
  that a library would replace real logic.
- Domain-specific business logic resembling a library but encoding rules no general library provides
  -- a pricing-eligibility state machine, a cache keyed on business rules.
- A reimplementation the author deliberately chose to avoid a dependency: where a comment or the
  commit message states that intent, respect it.
- A capability with no clear industry-standard library. Never invent one.
- Generated or vendored code.
