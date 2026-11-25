# Service Metrics Instrumentation

A newly-added instrumentable surface -- a business outcome or an operational signal the service framework and infrastructure do not already report -- emits a named custom metric.

## Why

Business outcomes are the domain state transitions and decisions the business measures for volume, conversion, and drop-off. A new transition or failure path shipped without a metric keeps its success rate, volume, and failure rate invisible until an incident forces a code change to add one.

## Diff scope

Flag only a surface this change adds or modifies. A pre-existing operation, branch, or call on an unchanged context line stays untouched even where the change edits code around it -- instrumenting untouched code widens the change past its purpose.

## Mechanism first

Determine the mechanism the code already uses from diff-visible evidence and phrase the remedy as a call in that mechanism:

- an injected metrics client, recorder, or meter;
- an embedded-metric-format or structured-metrics logger;
- an OpenTelemetry or StatsD-style meter;
- a project-specific emitter.

Where the changed file shows no mechanism, name the gap rather than inventing an API.

## Flag

### Business-outcome transition with no count metric

A domain state change or decision the business measures -- a resource created, an order placed, a payment captured or declined, a request approved or rejected, a subscription renewed or cancelled, a workflow step transition -- with no count metric anywhere on its call chain.

Emit the count once, at the layer owning the transition (the domain or service method, not every caller), on both the success and the failure or rejection branch so conversion and drop-off are measurable.

Trace the call chain visible in the diff first: where the changed code delegates to a method or shared emitter that already counts this functional event, there is no finding; where it is counted at a less appropriate layer, suggest relocating it rather than adding a duplicate.

### Dependency call with no latency and fault metric

A new call to an external dependency -- downstream service, datastore, queue, cache -- with no per-call latency and fault metric. The framework emits only whole-operation latency; a specific dependency's latency and error rate are not auto-provided and are the first signal on-call needs when that dependency degrades.

### Failure or fallback branch with no count

A new catch, fallback, retry, or circuit-breaker branch with no count metric for the failure or the fallback taken, so its rate is alarmable.

### Cache, batch, and stream paths

A new cache read path with no hit and miss metric; a new batch or stream processor with no processed, failed, and dead-letter-routed counts.

## Every finding states

- the metric name, its type -- count, time, or level;
- whether it is a business-outcome or an operational metric;
- why the framework or infrastructure does not already provide it;
- the emission call to add, in the mechanism the file uses.

## Do NOT flag

- An outcome already counted elsewhere on its call chain. Where a method the changed code delegates to, or a shared emitter it invokes, already emits the same functional business metric, a second count is the defect. The event is counted once, at the layer owning the transition.
- Metrics the service framework emits per request with no code: request latency, fault (server error), error (client error), availability, throttle count. Never ask to re-add these at the request boundary.
- Metrics the managed platform emits automatically:
  - serverless functions: invocations, errors, duration, throttles, concurrency;
  - API gateways: request count, 4xx, 5xx, latency;
  - managed databases: consumed capacity, throttled requests, system errors;
  - queues: depth, oldest-message age;
  - containers and hosts: CPU, memory;
  - load balancers: request count, target response time, status-code counts.

  Reimplementing these in application code is never the remedy.
- Alarm, dashboard, and metric-math definitions. They declare monitoring infrastructure, not runtime instrumentation.
- A surface that already emits an appropriate metric on an added line.
- Non-behavioral changes: configuration, dependency wiring, data, DTO, or model declarations, pure getters and mappers, log-only helpers.
- A surface with no business or operational significance.
