# Observability Considerations

Prompts for the design's Observability section. Instrument at design time -- telemetry
bolted on after launch misses the signals that matter. Cover system and business; a
green infrastructure dashboard hides silent product regressions. Mark N/A with reason.

## Service-Level Indicators & Objectives

- Define an indicator per critical user journey: availability, latency, correctness, freshness.
- Set objective targets and error budgets; budget burn drives alarms and release decisions.
- Each indicator represents the customer's experience, not the server's.

## System / Operational Metrics

- Request-driven components: request rate, error rate, and latency (50th/90th/99th percentile) per endpoint/dependency.
- Resources: utilization, saturation, and errors (processor, memory, threads, connections, queues, disk).
- Per-dependency: call rate, error rate, latency, timeout/retry/circuit-breaker counts.
- Queues/streams: depth, age of oldest message, processing lag, dead-letter-queue count.

## Business / Product Metrics

- Domain event rates (orders placed, jobs completed, signups) -- the value delivered.
- Funnel / conversion steps and drop-off; success vs attempt for key flows.
- Revenue- or outcome-impacting signals; what a stakeholder asks about during an incident.
- Who consumes each metric (on-call, product, finance) and what decision it drives.

## Logging

- Structured (key-value), queryable, consistent field names.
- Correlation/request/trace identifiers propagated end-to-end to stitch a request across services.
- Levels with intent (error = actionable, warn = suspicious, info = audit trail); avoid log spam.
- Sensitive-data handling: no personal data or secrets in logs; redaction; retention and access controls.

## Tracing

- Distributed traces across service and asynchronous boundaries; propagate context through queues.
- Spans on external calls, database queries, and expensive internal steps.
- Sampling strategy that preserves error/slow traces while bounding cost.

## Dashboards

- Operational view (rate/errors/latency, utilization/saturation, dependencies) for on-call.
- Business view (domain measures, funnels) for product/stakeholders.
- Per audience and per critical journey; the first screen answers "is it healthy?".

## Alarms

- Derived from service-level objectives (error-budget burn) and failure modes (see failure-recovery.md Detection).
- Alarm on symptoms (user-visible indicator breach) over causes; cause metrics aid diagnosis.
- Every alarm actionable and owned, with a linked runbook; no alarm without a response.
- Detect absence of work (zero throughput, stalled queue), not only error spikes.

## Instrumentation Cost & Cardinality

- Metric dimensions/tags: bound cardinality; high-cardinality labels explode cost and storage.
- Telemetry volume vs value; sampling and aggregation trade-offs.
- Emit at the source; backend-neutral naming so the telemetry store can change.
