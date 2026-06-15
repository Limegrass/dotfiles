# Rollout & Migration Considerations

How the change reaches production from the current state -- safely and reversibly.
Forward-direction counterpart to failure-recovery.md (which covers getting back to healthy).

## Deployment Strategy

- Phased / canary / blue-green / dark launch; rollout %, bake time, automated promotion gates.
- Feature flags / kill switches; default state; flag cleanup plan.

## Compatibility

- Backward and forward compatibility across versions; interface and schema versioning.
- Consumer impact; coordinated vs independent deploys; deprecation windows.

## Data Migration

- Backfill plan; online vs offline; dual-write / dual-read; shadow reads.
- Volume, duration, throttling; idempotent and resumable; verification + reconciliation.

## Cutover

- Sequence and dependencies; point of no return; validation gate at each step.
- Coexistence period of old and new paths; traffic-shift mechanism.

## Rollback

- Forward-fix vs rollback criteria; measured time to roll back.
- Migration rollback-safety: expand/contract, no destructive step before cutover.
- See failure-recovery.md for recovery mechanisms once live.
