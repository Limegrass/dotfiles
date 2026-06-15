# Operational Readiness: <title>

Companion to design-<name>.md. Required before launch. A launch gate, not a nice-to-have.
See references/rollout-migration.md and references/accessibility.md for checklists.

## Rollout & Migration

Strategy: <phased/canary/blue-green/dark launch; rollout %, bake time, automated gates>

Feature flags / kill switches: <what's gated; default state; cleanup plan>

Compatibility: <backward/forward compat; interface and schema versioning; consumer impact; coordinated vs independent deploy>

Data migration: <backfill plan; online vs offline; dual-write/dual-read; volume + duration; idempotent + resumable; verification>

Cutover: <sequence and dependencies; point of no return; validation gate at each step; coexistence period>

Rollback: <forward-fix vs rollback criteria; migration rollback-safety (expand/contract); see design Failure & Recovery>

## Accessibility & Internationalization [if: user-facing]

Accessibility: <target conformance against recognized accessibility guidelines; keyboard navigation; screen-reader semantics; contrast; testing>

Internationalization: <locale support; externalized strings; right-to-left layout; date/number/currency; time zones; text expansion>

## Operational Sign-off

- Observability in place (alarms, dashboards, runbooks -- see design Observability).
- On-call ownership and escalation defined.
- Upstream/downstream dependencies and their service-level agreements confirmed.
