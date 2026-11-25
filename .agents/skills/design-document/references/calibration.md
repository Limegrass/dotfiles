# Calibration

The bar: shallow opinion vs lifecycle-deep, evidence-backed design.

## Bad (opinion-driven, shallow)

> ## Approaches
>
> We should use PostgreSQL because it's mature.
>
> ## Alternative
>
> MongoDB. Rejected: document stores are overhyped.
>
> ## Recommendation
>
> Use PostgreSQL.

Why bad: no criteria, no evidence, no trade-offs, dismisses the alternative without
exploration, ignores everything past day-one build (operate, recover, secure, scale, cost).

## Good (evidence-backed, lifecycle-deep)

> ## Approach A: PostgreSQL
>
> Relational model fits order data (strong foreign-key constraints, transactional integrity for payment flows).
> Team has 3 years operational experience. Read replicas handle projected 10k requests per second.
> Trade-off: schema migrations require a downtime window without logical replication.
> Build: low (existing infrastructure, known failure modes).
> Operate: replica lag serves stale reads under write spikes; primary failover ~30s.
> Recover: point-in-time recovery from backups; replication catch-up; reconcile via queries against audit table.
> Maintain: low -- mature tooling, deep hiring pool, well-understood on-call.
> Retire: high reversibility -- standard relational dump/restore migrates out (two-way door).
> Cost: ~$2k/mo at projected load (managed instances + replicas); scales linearly.
> Performance: 10k requests/sec on 3 replicas; ~50k requests/sec vertical ceiling before sharding needed.
> Security & privacy: private-network; row data is personal data -- column encryption + audit table.
>
> ## Approach B: managed key-value store
>
> Single-digit-millisecond latency at any scale. No connection-pool management.
> Trade-off: no cross-item transactions (payment flow needs a saga pattern, +2 weeks).
> Build: medium (saga implementation, new operational model for team).
> Operate: hot-partition throttling; secondary-index eventual consistency surfaces stale reads.
> Recover: point-in-time recovery restore; stream replay for reprocessing; reconciliation custom-built per access pattern.
> Maintain: medium -- managed service lowers ops, but new access patterns force table/secondary-index redesign.
> Retire: low reversibility -- access-pattern lock-in; exit requires query-layer rewrite (one-way door).
> Cost: ~$3.5k/mo at projected load, on-demand; egress + secondary indexes multiply with new patterns.
> Performance: horizontal to any request rate; single hot partition caps one key at ~3k requests/sec.
> Security & privacy: managed encryption; fine-grained access control; same personal-data handling obligations.
>
> ## Evaluation
>
> Weighted criteria -- consistency (0.3), recoverability (0.2), cost (0.2), latency (0.15), maintenance (0.15).
> Consistency and recoverability dominate: payment correctness is non-negotiable and incidents must be reversible.
> PostgreSQL scores 0.85, the key-value store scores 0.70. Consistency, simpler reconciliation, and lower cost drive the gap.
>
> ## Observability
>
> Objective: 99.9% of order reads under 50ms; payment writes 99.95% success (error budget 0.05%).
> System: request rate, error rate, 50th/99th-percentile latency per endpoint; resources: connection-pool saturation, replica lag.
> Business: orders/min, payment success rate, checkout funnel drop-off -- alarmed to catch silent regressions.
> Traces across checkout -> payment -> ledger; structured logs keyed by order id; error-budget-burn alarms with runbooks.
>
> ## Failure & Recovery
>
> Detection: alarm on replica lag over 5s and payment-write error rate; time-to-detect under 1 min.
> Bad deploy: canary 1 box, auto-rollback on error-rate alarm; migrations expand/contract (rollback-safe).
> Reprocessing: payment writes idempotent on order id; failures to dead-letter queue, redrive after fix.
> State divergence: nightly ledger-vs-order reconciliation; drift alarms; manual repair runbook.
> Validation: fuzz payment payloads; load to 2x request rate + 1h soak; game-day the failover and dead-letter-queue redrive in a pre-production stage.

Companion reviews (separate docs) carry the rollout/migration plan and the security/privacy/compliance assurance.
