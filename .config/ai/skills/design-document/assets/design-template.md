# Design: <title>

Core design doc. Companion reviews (separate, required before build/launch):
design-<name>-readiness.md (operational readiness), design-<name>-security-privacy.md (security & privacy).

## Problem Space

<what problem we're solving. scope boundaries. what's NOT in scope.>

## Constraints

- <constraint>: <hard limit and source (service-level agreement, budget, compliance, etc.)>

## Goals & Non-Goals

Goals:
- <measurable outcome>

Non-Goals:
- <explicitly excluded outcome>

## Approaches

Score every approach across the full lifecycle and cross-cutting axes, not just build effort.

### <Approach A>

<how it works. architecture sketch or flow description.>

Trade-offs:
- Gain: <what improves -- quantified>
- Lose: <what worsens or complicates -- quantified>

Evidence: <benchmark/prototype numbers, prior art, similar system -- cite source>

Lifecycle:
- Build: <effort, risk, unknowns -- low/med/high>
- Operate: <failure modes -- how it breaks/degrades>
- Recover: <rollback, redrive/replay, reconciliation -- path back to healthy>
- Maintain: <ongoing operational burden, evolvability, on-call cost>
- Retire: <reversibility -- cost to undo/migrate; one-way vs two-way door>

Cost: <build + run + at-scale -- order of magnitude>

Performance: <throughput/latency at target load; scaling ceiling>

Security & privacy: <attack surface, sensitivity of data handled, residency/compliance fit>

### <Approach B>

<how it works. architecture sketch or flow description.>

Trade-offs:
- Gain: <what improves -- quantified>
- Lose: <what worsens or complicates -- quantified>

Evidence: <benchmark/prototype numbers, prior art, similar system -- cite source>

Lifecycle:
- Build: <effort, risk, unknowns -- low/med/high>
- Operate: <failure modes -- how it breaks/degrades>
- Recover: <rollback, redrive/replay, reconciliation -- path back to healthy>
- Maintain: <ongoing operational burden, evolvability, on-call cost>
- Retire: <reversibility -- cost to undo/migrate; one-way vs two-way door>

Cost: <build + run + at-scale -- order of magnitude>

Performance: <throughput/latency at target load; scaling ceiling>

Security & privacy: <attack surface, sensitivity of data handled, residency/compliance fit>

## Evaluation Criteria

Criteria span the lifecycle plus cross-cutting axes -- include recoverability, maintainability,
performance, security, privacy, and cost, not only build effort.

| Criterion       | Weight | Approach A | Approach B |
| :-------------- | :----- | :--------- | :--------- |
| <criterion>     | <0-1>  | <score>    | <score>    |

Weight rationale: <why these weights -- which criterion dominates and why>

## Recommendation

<chosen approach + primary justification. why this over others.>

## Observability

For the recommended design. Cover system and business; infrastructure-green hides silent product regressions.
Mark N/A with reason. See references/observability.md for the dimension checklist.

Indicators & objectives: <user-facing service-level indicators + targets + error budget per critical journey>

System metrics: <services -- request rate, errors, latency per endpoint/dependency; resources -- utilization, saturation, errors>

Business metrics: <domain measures -- key event rates, funnel/conversion, value delivered; who consumes each>

Logging: <structured fields, correlation/trace identifiers, levels, personal-data handling>

Tracing: <distributed spans across boundaries; sampling>

Dashboards: <operational view + business view; per audience>

Alarms: <error-budget-burn + failure-mode driven; symptom-based; actionable; owned with runbook>

## Performance & Scalability

For the recommended design. Estimate against a load model. See references/performance.md.

Load model: <expected + peak throughput; read/write mix; growth projection>

Latency budget: <50th/99th-percentile targets per critical path; end-to-end breakdown>

Capacity & bottlenecks: <bottleneck resource; headroom at expected/peak; what saturates first>

Scaling strategy: <vertical/horizontal/sharding; partition key; autoscaling triggers and limits>

Limits & hotspots: <hard ceilings, quotas, hot keys; behavior beyond capacity -- shed/queue/fail>

## Failure & Recovery

Deep-dive for the recommended design (per-approach Lifecycle.Recover is the comparison; this is the plan).
Mark N/A with reason. See references/failure-recovery.md for the dimension checklist.

Detection: <service-level breach + failure-mode alarms (see Observability); health checks; time-to-detect>

Blast radius: <worst-case scope; isolation/containment (cell, tenant, circuit breaker)>

Recovery:
- Bad deploy: <rollback strategy -- see Operational Readiness for the full rollout/migration plan>
- Reprocessing: <retry/backoff, idempotency, dead-letter queue, redrive/replay after fix>
- State divergence: <anti-entropy/reconciliation, drift detection, backfill from log/snapshot>
- Data loss: <backups, point-in-time recovery, tested restore>
- Degradation: <graceful degradation, fail open vs closed, backpressure/load shedding>

## Resilience Validation

- Fuzz: <adversarial/malformed input at trust boundaries>
- Load/soak: <at and beyond capacity; long-running stability>
- Failure injection: <dependency latency/errors, instance loss, partition>
- Game-day / drills: <recovery rehearsal; runbooks; measured time-to-recover>

## Cost

For the recommended design. Estimate with numbers. See references/cost.md for the checklist.

- Cost drivers: <what dominates -- compute, storage, input/output, egress, licensing, people>
- Unit economics: <cost per request/tenant/gigabyte/job; scales sub-linearly or blows up?>
- Scaling cost: <cost at 1x and 10x projected load; where the curve bends>
- Controls: <budgets, cost alarms, autoscaling, right-sizing, time-to-live expiry/tiering, idle shutdown; owner>

## Maintenance

- Ownership: <who operates and evolves this after launch>
- Evolvability: <how new requirements land; extension points; expected churn>
- Operational cost: <on-call load, toil, recurring infrastructure/licensing>
- Deprecation: <how this is retired or replaced when superseded>

## Extended Reviews

Separate companion artifacts; required before build/launch:
- Operational Readiness: design-<name>-readiness.md -- rollout & migration, accessibility/internationalization
- Security & Privacy Review: design-<name>-security-privacy.md -- threat model, privacy assessment, compliance

## Open Questions

- <unresolved item>: <what's needed to resolve, who owns it>
