---
name: plan-for-performance
description: >
  Guides implementation planning from a performance perspective.
  Invoke when delegated to plan changes focusing on efficiency,
  algorithmic complexity, and resource usage.
---

# Planning for Performance

Analysis and recommendations only. No modifications.

## Analysis

Non-exhaustive. Explore beyond these when context warrants.
For each affected component, evaluate:

1. `Algorithmic complexity`: time and space on hot path.
   State O() explicitly. Identify input that determines N.
2. `Allocation patterns`: objects created per request/iteration?
   Reuse, pool, or pre-allocate where lifetime allows.
3. `I/O amplification`: calls in loops, repeated serialization,
   unbatched network/disk access. Each I/O call has latency floor.
4. `Caching opportunity`: same computation repeated with same inputs?
   Cache if: computation expensive AND invalidation tractable.
5. `Data structure fit`: chosen for actual access pattern?
   List vs Set vs Map vs sorted structure. Wrong choice = hidden O(n).
6. `Scaling behavior`: 10x input growth: linear degradation or cliff?
   Identify non-linear scaling points.

## Red Flags

- O(n^2) hidden in nested iterations (especially with DB/API calls)
- Repeated parsing/serialization of same data
- Allocating in tight loops (GC pressure, fragmentation)
- Synchronous I/O blocking concurrent path
- Unbounded collections growing with request volume
- String concatenation in loops (use builder/buffer)

## Scope Boundaries

Deprioritize:

- Cold paths (startup, config loading, error formatting)
- Code called <100 times with small N (optimize if profiler says so)
- Readability-destroying micro-optimizations without measured bottleneck

Prioritize: request hot path, loop bodies, high-QPS endpoints, data-proportional operations.

## Output

```markdown
### Performance Analysis

#### Findings

<What's slow/wasteful, where (file:line), complexity, estimated impact>

#### Proposed Changes

<File + code-level changes. Complexity before/after.
Each explains WHY it improves efficiency at scale.>

#### Benchmarking Suggestions

<How to validate gains. Specific inputs, expected improvement range.>

#### Trade-offs

<Cost to readability or added complexity. Be specific.>
```

## Calibration

Bad (premature, unmeasured):

> "Use a HashMap instead of a List for better performance."

Good (specific, complexity-aware):

> "`findUser(userId)` at UserService.java:62 iterates `allUsers` list (O(n), n=active users).
> Called per-request at ~500 QPS. With 50K users = 25M comparisons/sec.
> Fix: index users in `Map<UserId, User>` at load time. Lookup becomes O(1).
> Trade-off: +48 bytes/entry memory overhead (~2.4MB for 50K users). Acceptable.
> Benchmark: `findUser` p99 latency before/after with 50K synthetic users."
