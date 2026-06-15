---
name: design-document
description: >
  Explore solution space for complex changes. Produce design documents comparing
  approaches with evidence, trade-offs, and recommendations. Invoke when asked to
  design a system, explore approaches, write a design doc, compare solutions, or
  when a problem has no obvious single approach. Also triggers on "RFC",
  "technical design", "how should we build", "explore options for".
---

# Design Document

## Routing

Redirect to `spec-driven-development` if approach already known, single component,
or clear bug fix. Design doc = multiple viable approaches with non-obvious trade-offs.

## Artifacts

- Core design doc -- the decision: `design-{name}.md` from [`design-template.md`][design-template].
- Operational Readiness (companion) -- `design-{name}-readiness.md` from
  [`operational-readiness-template.md`][orr-template]: rollout & migration, accessibility/internationalization.
- Security & Privacy Review (companion) -- `design-{name}-security-privacy.md` from
  [`security-privacy-template.md`][sp-template]: threat model, privacy assessment, compliance.

`{name}` = short identifier from the design title, shared across all three artifacts.

Companions are separate artifacts required before build/launch, not lower priority.
Core carries decision-shaping security/privacy/cost/performance posture so no approach is
chosen over a hidden blocker; companions carry the detailed assurance.

## Process

Core requirements (sequence flexible). Steps 1-9 produce the core doc; 10-11 the companions:

1. Problem space boundaries. Not solution -- the problem. What's out of scope.
   Existing system involved -> ground current-state in real behavior (invoke
   `domain-documentation`), not assumptions.
2. Hard constraints. Budget, timeline, tech debt, compliance, team capacity, service-level agreements.
   Constraints eliminate options early; surface them first.
3. Research 2-3+ approaches. Score each across the full code lifecycle:
   - Mechanism (architecture sketch or flow)
   - Trade-offs (gain vs lose, quantified where possible)
   - Evidence (benchmark, prototype, prior art, similar system) -- cite source
   - Build: complexity (effort, risk, unknowns)
   - Operate: failure modes (how it breaks, how it degrades)
   - Recover: rollback, redrive/replay, reconciliation -- path back to healthy
   - Maintain: ongoing operational burden, evolvability, on-call cost
   - Retire: reversibility (cost to undo or migrate away -- one-way vs two-way)
   - Cost: build + run + at-scale, order of magnitude
   - Performance: throughput/latency at target load; scaling ceiling
   - Security & privacy: attack surface, data exposure, residency/compliance fit
4. Evaluation criteria. Explicit, weighted if useful. Span lifecycle + cross-cutting axes
   (recoverability, maintainability, performance, security, privacy, cost), not just build
   effort. Justify weights (why a criterion dominates).
5. Evaluate with data. Recommend with justification. Steps 6-9 detail the recommended design.
6. Observability. Service-level indicators and objectives (what "healthy" means + error budget),
   system metrics (request rate, errors, and latency for services; utilization, saturation, and
   errors for resources), and business/product metrics (domain measures, not just infrastructure),
   plus structured logging, tracing, dashboards, and objective-derived alarms -- [`observability.md`][observability].
7. Performance & scalability. Load model, latency budget, capacity/bottlenecks, scaling
   strategy, and limits/hotspots -- [`performance.md`][performance].
8. Failure & recovery. Detection (alarms from service-level objectives and failure modes), blast
   radius, recovery paths (rollback/feature-flag, retry/redrive/replay, reconciliation/backfill,
   graceful degradation), and resilience validation (fuzz, load/soak, failure injection, game-day,
   recovery drills) -- [`failure-recovery.md`][failure-recovery].
9. Cost. Cost drivers, unit economics, scaling cost, and controls -- estimate with numbers --
   [`cost.md`][cost].
10. Operational Readiness review (companion doc). Rollout & migration (phased/canary, feature
    flags, compatibility, data migration/backfill, cutover, rollback) and accessibility/internationalization
    [if: user-facing] -- [`rollout-migration.md`][rollout-migration], [`accessibility.md`][accessibility].
11. Security & Privacy review (companion doc). Threat model (trust boundaries, authentication/authorization,
    secrets, supply chain, audit, abuse/denial-of-service), data-privacy assessment [if: personal data], and
    compliance/regulatory [if: regulated] -- [`security.md`][security], [`data-privacy.md`][data-privacy],
    [`compliance.md`][compliance].
12. Open questions: research first. Only surface questions requiring user input
    (access, preference, org context). False certainty compounds into implementation surprises.

## Rules

- Each approach gets full exploration, never dismissal (dismissing = spec behavior)
- Compare across the full lifecycle -- build, operate, recover, maintain, retire.
  Build is the cheapest phase; operation and maintenance dominate total cost of ownership.
  Cheapest to build is often costliest to own.
- Evidence cites a verifiable source -- benchmark numbers, prior art, similar system.
  Unattributed claim = opinion; opinions don't justify resource commitment.
- Quantify comparatives. "Faster/cheaper" -> magnitude, or mark unknown. Vague comparison hides risk.
- Recommendation separate from exploration (readers evaluate independently first)
- Observability, performance, reliability (failure & recovery), and cost are first-class core
  outputs -- compared across approaches and detailed for the chosen design.
- Rollout/migration, the security threat model, privacy (a privacy assessment), compliance, and
  accessibility are required before build/launch and live in companion review docs -- separate
  artifacts, not lower priority. Keep decision-shaping posture (security/privacy/cost/performance)
  in the core comparison so no approach is chosen over a hidden blocker. Bolt-on security and privacy leak.
- Open questions first-class (unknowns acknowledged, not hidden)
- Declarative voice. State decisions, not deliberation history (history lives in version control).
- ONE author. Conflicting input -> document both, author recommends.

## Output

Core: `design-{name}.md`. Load [`design-template.md`][design-template]; adapt sections.

Companions (separate files, produce when warranted):
- `design-{name}-readiness.md` -- load [`operational-readiness-template.md`][orr-template].
- `design-{name}-security-privacy.md` -- load [`security-privacy-template.md`][sp-template].

Calibration -- shallow vs lifecycle-deep examples (the bar): [`calibration.md`][calibration].

Post-design: invoke `architecture-decision-record` for decision,
`spec-driven-development` for implementation planning.

## Quality

### Core design doc

- [ ] Problem scope defined without prescribing solution
- [ ] Constraints listed before approaches
- [ ] Each approach scored: lifecycle (build/operate/recover/maintain/retire) + cost + performance + security/privacy posture
- [ ] Decision-shaping security/privacy/cost/performance posture visible in the comparison (no hidden blocker)
- [ ] Recovery compared across approaches, not only the chosen one
- [ ] Evidence attributed to a source
- [ ] Evaluation criteria explicit, span lifecycle + cross-cutting axes, weights justified
- [ ] Recommendation separable from exploration
- [ ] Observability: indicators and objectives + system metrics (rate/errors/latency, utilization/saturation) + business metrics + logging/tracing/dashboards/alarms
- [ ] Performance & scalability: load model, latency budget, scaling strategy, limits
- [ ] Failure & recovery: detection + recovery paths + resilience validation (or N/A with reason)
- [ ] Cost: compared across approaches + cost model and controls for chosen design
- [ ] Open questions acknowledged; no approach dismissed; declarative voice

### Companion: Operational Readiness

- [ ] Rollout & migration: strategy, compatibility, data migration/backfill, cutover, rollback
- [ ] Accessibility & internationalization addressed (or N/A -- not user-facing)

### Companion: Security & Privacy Review

- [ ] Security threat model: trust boundaries, authentication/authorization, secrets, supply chain, audit, abuse/denial-of-service
- [ ] Data privacy assessment: classification, retention/deletion, access, residency (or N/A -- no personal data)
- [ ] Compliance & regulatory: standards, audit evidence, certifications, licensing (or N/A -- not in scope)

## Traps

- Premature convergence. First approach feels "obvious". Force 2+ more.
  Obvious choice often wins; exploration strengthens justification.
- Scope creep. Each approach solves SAME problem.
  Different problems solved -> problem scope undefined.
- Missing constraints. Ask: what CAN'T we do?
  Unspoken constraints surface late and invalidate approaches.
- Unquantified trade-offs. "Faster" without numbers can't be evaluated. Quantify or label unknown.
- Build-cost myopia. Approaches compared only on implementation effort.
  Score the whole lifecycle -- the option cheapest to build is often costliest to operate and maintain.
- Observability afterthought / infrastructure-only metrics. Processor graphs can't detect a silent
  product regression or prove value. Instrument business outcomes and define indicators and objectives up front.
- Performance hand-waving. "Scales fine" without a load model. State expected/peak load,
  latency budget, and the resource that saturates first.
- Happy-path-only design. Failure modes listed, recovery omitted. Ask: how do we get back to healthy?
  Bad deploy, poison message, divergent state, dead dependency each need an answer -- for every approach.
- Untested recovery. Rollback/redrive/restore that was never exercised fails when first needed.
  Plan a game-day or drill.
- Extended != optional. The companion reviews are launch gates, not nice-to-haves.
  Keep security/privacy posture in the core comparison; complete the reviews before build/launch.
- Cost hand-waving. "Cheap enough" without numbers. Estimate build + run + at-scale;
  the cheapest prototype can be the costliest fleet.
- Design by committee. Conflicting input -> document both, author recommends.

[design-template]: assets/design-template.md
[orr-template]: assets/operational-readiness-template.md
[sp-template]: assets/security-privacy-template.md
[calibration]: references/calibration.md
[observability]: references/observability.md
[performance]: references/performance.md
[failure-recovery]: references/failure-recovery.md
[cost]: references/cost.md
[rollout-migration]: references/rollout-migration.md
[accessibility]: references/accessibility.md
[security]: references/security.md
[data-privacy]: references/data-privacy.md
[compliance]: references/compliance.md
