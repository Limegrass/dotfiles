---
name: plan-for-performance
description: >
  Plan implementation focusing on performance: algorithmic complexity,
  resource usage, I/O efficiency, scaling behavior. Invoke when
  delegated to analyze changes from performance perspective.
---

# Planning for Performance

Produce findings and recommendations, not implementations.

## Analysis

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
7. `Resource lifecycle`: connections, streams, handles opened but not closed
   or held longer than needed. Leak under load = eventual OOM/exhaustion.
8. `Serialization cost`: object<->wire conversion on hot path.
   Repeated serialization of same object, oversized payloads, unused fields in response.

## Traps

- Measure first. Optimizing without profiling is superstition.
- Async moves latency, doesn't remove it. Total work unchanged.
- Cache invalidation bugs worse than cache misses.
- "Constant factor" matters when N always small -- O(1) with huge constant loses to O(n) with n<50.
- O(n^2) hides in nested iterations (especially with DB/API calls inside loops).
- Unbounded collections growing with request volume = memory leak with extra steps.
- String concatenation in loops: O(n^2) in many runtimes without builder. Use StringBuilder/join.
- Connection pool too small under load: threads block waiting, throughput collapses despite available CPU.

## Scope

Deprioritize: cold paths (startup, config, error formatting), code called <100 times with small N, micro-optimizations without measured bottleneck.

Prioritize: request hot path, loop bodies, high-QPS endpoints, data-proportional operations.

## Output

```markdown
### Performance Analysis

#### Findings
<What's slow/wasteful, where (file:line), complexity, estimated impact>

#### Proposed Changes
<File + code-level changes. Complexity before/after.>

#### Benchmarking Suggestions
<How to validate gains. Specific inputs, expected improvement range.>

#### Trade-offs
<Cost to readability or added complexity.>
```

## Calibration

Bad:
> "Use a HashMap instead of a List for better performance."

Good:
> "`findUser(userId)` at UserService.java:62 iterates `allUsers` list (O(n), n=active users).
> Called per-request at ~500 QPS. With 50K users = 25M comparisons/sec.
> Fix: index users in `Map<UserId, User>` at load time. Lookup becomes O(1).
> Trade-off: +48 bytes/entry memory overhead (~2.4MB for 50K users). Acceptable.
> Benchmark: `findUser` p99 latency before/after with 50K synthetic users."
