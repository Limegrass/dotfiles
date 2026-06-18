# Performance & Scalability Considerations

Estimate against a load model; "fast enough" is not a number. State assumptions explicitly.

## Load Model

- Expected and peak throughput (requests, transactions, or events per second); read vs write mix.
- Growth projection over the planning horizon; burst vs sustained.

## Latency Budget

- 50th/90th/99th-percentile targets per critical path; end-to-end breakdown across hops.
- Tail latency under load and contention; timeout budget per dependency.

## Capacity & Bottlenecks

- Bottleneck resource (processor, memory, input/output, connections, locks, downstream service).
- Headroom at expected and peak; what saturates first.

## Scaling Strategy

- Vertical vs horizontal; sharding/partitioning key; statelessness.
- Autoscaling triggers and limits; cold-start and warm-up behavior.
- Caching, batching, async offload where they change the curve.

## Limits & Hotspots

- Hard ceilings and quotas; hot keys/partitions; thundering herd.
- Behavior beyond capacity: shed load, queue, or fail -- and how that surfaces.

## Traps

- Performance hand-waving. "Scales fine" without a load model. State expected/peak load,
  latency budget, and the resource that saturates first.
