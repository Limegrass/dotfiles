# Failure & Recovery Considerations

Prompts for comparing recovery across approaches and for deep-diving the chosen
design's Failure & Recovery and Resilience Validation sections.
Not all apply -- select by system nature (stateless service, queue consumer, batch
pipeline, stateful store, scheduler). Answer each relevant prompt in the design,
or mark N/A with a reason. An unanswered prompt is an unowned outage.

## Detection

- How is each failure mode detected -- alarm, metric, log, health check, customer report?
- Target time-to-detect. Silent failures are the worst class; close every blind spot.
- What signal separates degradation (slow, partial) from outage (down)?
- Is the absence of work detectable (stuck queue, halted scheduler, zero throughput)?

## Containment / Blast Radius

- Worst-case scope of each failure: single request, user, tenant, shard, region, fleet-wide?
- Isolation: bulkheads, cell-based architecture, per-tenant quotas, circuit breakers.
- Overload handling: backpressure, load shedding, admission control, rate limits.
- Does one bad input/tenant degrade everyone (noisy-neighbor, poison pill)?

## Recovery: Bad Deploy

- Rollback: automated on alarm? canary or blue/green? measured time to roll back?
- Forward-fix vs rollback decision criteria.
- Feature flags / kill switches to disable a path without redeploy.
- Migration safety: are schema/data changes backward-compatible so rollback is safe
  (expand/contract, dual-write, no destructive step before cutover)?

## Recovery: Message / Job Processing

- Retry policy: bounded attempts, exponential backoff, jitter.
- Idempotency: safe to reprocess the same item? dedupe key / idempotency token?
- Dead-letter / parking for poison messages so they don't block the stream.
- Redrive / replay: can the dead-letter queue or source be reprocessed after a fix? is ordering preserved?
- Poison-pill isolation: one bad item must not stall the partition/queue.

## Recovery: State Divergence

- Anti-entropy: periodic reconciliation between sources of truth (ledger vs projection,
  cache vs store, replica vs primary).
- Drift detection: alarmed automatically, or only found by customers?
- Repair: automated reconciliation vs manual runbook; idempotent so repair is safe to rerun.
- Rebuild: backfill / replay from event log or snapshot to reconstruct derived state.

## Recovery: Data Loss / Corruption

- Backups + retention + point-in-time recovery; restores actually tested (not assumed).
- Immutable audit log / event sourcing for reconstruction.
- Guardrails against accidental destructive operations (soft delete, deletion protection, multi-factor delete protection).

## Degradation

- Graceful degradation: which features shed first? read-only or cached/stale serving?
- Dependency failure: fail open vs fail closed -- state the correctness/security trade-off.
- Timeouts, retry budgets, and circuit breakers on every remote dependency.

## Resilience Validation

- Fuzz: malformed/adversarial inputs at trust boundaries; property-based tests on invariants.
- Load / soak / stress: behavior at, near, and beyond capacity; leaks and drift over hours.
- Failure injection / chaos: dependency latency and errors, instance loss, network partition,
  clock skew, disk/quota exhaustion.
- Game-day: rehearse recovery procedures end-to-end; validate alarms fire, runbooks work,
  and time-to-recover meets the service-level agreement.
- Recovery drills: practice rollback, dead-letter-queue redrive, reconciliation, and restore-from-backup
  before the incident, not during it.

## Operability / Maintenance

- Runbook per failure mode: detection -> diagnosis -> mitigation, with exact commands.
- Are mitigations self-service/automated, or do they require a specific expert?
- On-call signal quality: actionable alarms only; no alert fatigue.
- Ongoing burden: toil, recurring upkeep, dependency/version churn over the system's life.
