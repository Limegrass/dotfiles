# Cost Considerations

Cost is a design axis, not an afterthought. Estimate with numbers; "cheap enough" is not an
estimate. Compare total cost across approaches, then model the chosen design.

## Cost Drivers

- What dominates: compute, storage, input/output requests, network egress, licensing, or people/ops?
- Fixed vs variable; baseline (idle) vs peak cost.

## Unit Economics

- Cost per meaningful unit (request, tenant, gigabyte, job). Sub-linear, linear, or blow-up?
- Cross-zone, cross-region, and egress charges hidden in the architecture.

## Scaling Cost

- Cost at 1x and 10x projected load; where the curve bends.
- Over-provisioning vs autoscaling trade-offs.

## Build vs Run vs Maintain

- One-time build cost vs recurring run cost vs ongoing maintenance/on-call.
- Cheapest to build is often costliest to operate -- compare the whole lifecycle.

## Controls

- Budgets and cost alarms; anomaly detection on spend.
- Levers: autoscaling, right-sizing, time-to-live expiry, tiering, archival, idle shutdown, caching, batching.
- Ownership: who watches spend and acts on it.

## Traps

- Cost hand-waving. "Cheap enough" without numbers. Estimate build + run + at-scale;
  the cheapest prototype can be the costliest fleet.
