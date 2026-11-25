# Spec: <title>

## Problem

<what + why + measurable impact (error rate, latency, frequency)>

## Acceptance Criteria

- [ ] <observable behavior or test assertion>
- [ ] <metric threshold>
- [ ] <edge case from Edge Cases section>

## Current State

<invocation path or behavior summary with inline code refs>

Code: [`<File> L#-L#`][current-order-handler] -- <role in current flow>

Evidence [if: observable data]:

```
<actual system output, query result, or metric>
```

## Desired State

<target behavior. invariant established.>

### Delta

| Aspect           | Before    | After     | Why      |
| :--------------- | :-------- | :-------- | :------- |
| <field/behavior> | <current> | <desired> | <reason> |

Expected output [if: transformation has concrete result]:

```
<expected output>
```

## Types & Schema [if: typed data changes]

- `<TypeName>`: [`<File> L#-L#`][type-order-item] -- <how affected>

## Approach

<solution strategy. why this method over others. key design decision.>

## Alternatives [if: non-trivial]

### <Alternative name>

<description of approach. how it would work.>

Rejected: <reason with evidence or trade-off analysis>.

## Edge Cases

- <case>: [`<File> L#`][edge-empty-array] -- <why exists>. Decision: <behavior or [TODO]>.

## Affected Components

- `<component>` (<new/modify/remove>): [`<File>`][component-order-service]. Risk: <low/med/high>.

## Implementation Plan [if: multiple commits]

1. `refactor(<scope>)`: <preparatory change>
2. `feat(<scope>)`: <core change>
3. `test(<scope>)`: <coverage for new behavior>

## Observability [if: production-facing]

- <signal>: `<metric/query>` -- expect <threshold/shape> post-deploy
- Dashboard: <link>

## Risks & Rollback [if: production-facing]

- <risk> (likelihood: <L>, impact: <I>): <mitigation>

Rollback: <revert strategy>

## Dependencies [if: blocked or blocking]

- <what>: <type> -- <status>. <link>

## Out of Scope

- <excluded item>

[current-order-handler]: https://github.com/<org>/<repo>/blob/<commit>/<path>#L44-L52
[type-order-item]: https://github.com/<org>/<repo>/blob/<commit>/<path>#L12-L18
[edge-empty-array]: https://github.com/<org>/<repo>/blob/<commit>/<path>#L47
[component-order-service]: https://github.com/<org>/<repo>/blob/<commit>/<path>
