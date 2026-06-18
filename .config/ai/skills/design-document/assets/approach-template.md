# Approach: <title>

Deep-dive for one approach under design-<name>.md. Use only for a large design where this approach
is itself a sub-design. The core doc compares this against the alternatives and recommends; this doc
holds the depth.

## Mechanism

<how it works in depth -- architecture, components, data and control flow, key interactions.>

## Trade-offs

- Gain: <what improves -- quantified>
- Lose: <what worsens or complicates -- quantified>

## Evidence

<benchmark/prototype numbers, prior art, similar system -- cite source>

## Simplicity

<moving parts, failure surface, cognitive load; ease of change -- distinct from build effort>

## Lifecycle

- Build: <effort, risk, unknowns>
- Operate: <failure modes; how it breaks/degrades>
- Recover: <rollback, redrive/replay, reconciliation -- path back to healthy>
- Maintain: <ongoing operational burden, evolvability, on-call cost>
- Retire: <reversibility -- cost to undo/migrate; one-way vs two-way door>

## Cost

<build + run + at-scale; dominant drivers and unit economics where they differ from alternatives>

## Performance

<throughput/latency at target load; scaling strategy and ceiling; bottleneck resource>

## Security & Privacy

<attack surface, data exposure, residency/compliance fit specific to this approach>

## Open Questions

- <unresolved item specific to this approach; what's needed to resolve>
