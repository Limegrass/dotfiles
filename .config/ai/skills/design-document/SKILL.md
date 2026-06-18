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

## Scope

Deliverable: `design-{name}.md` (the decision) from [`design-template.md`][design-template] -- problem,
compared approaches, recommendation, and the core deep-dives for the chosen design: observability,
performance & scalability, failure & recovery.

The comparison always carries each approach's cost, performance, and security/privacy posture so no
approach is chosen over a hidden blocker. Detailed reviews -- cost model, operational readiness
(rollout & migration, accessibility), security & privacy (threat model, privacy, compliance) -- are
optional; ask up front which to bring into scope. Include an opted-in review as core-doc sections or a
companion doc (`design-{name}-readiness.md`, `design-{name}-security-privacy.md`); omit the rest
entirely, never referenced as follow-ups.

## Process

Core requirements (sequence flexible). Settle scope up front (see Scope); steps 1-9 produce the
core decision, steps 10-12 run only for reviews the user opted into. Each step's checklist lives
in the linked reference -- load it when working that step.

1. Problem space boundaries. Not solution -- the problem. What's out of scope.
   Existing system involved -> ground current-state in real behavior (invoke
   `domain-documentation`), not assumptions.
2. Hard constraints. Budget, timeline, tech debt, compliance, team capacity, service-level agreements.
   Constraints eliminate options early; surface them first.
3. Devise 2-3+ approaches -- a mechanism sketch (architecture or flow) for each.
   Large design only (each approach is itself a sub-design): deep-dive each in its own doc from
   [`approach-template.md`][approach-template]; the core doc then synthesizes and compares them.
4. Compare approaches aspect by aspect: take one lens, evaluate every approach under it, and finish
   it before the next. Lenses:
   - Trade-offs (gain vs lose, quantified where possible)
   - Evidence (benchmark, prototype, prior art, similar system) -- cite source
   - Simplicity: moving parts, failure surface, cognitive load; ease of change (distinct from build effort)
   - Lifecycle: build (effort/risk/unknowns), operate (failure modes), recover (rollback/redrive/reconcile),
     maintain (burden/evolvability/on-call), retire (reversibility -- one-way vs two-way)
   - Cost posture: build + run + at-scale, order of magnitude
   - Performance posture: throughput/latency at target load; scaling ceiling
   - Security & privacy posture: attack surface, data exposure, residency/compliance fit
5. Evaluation criteria. Explicit, weighted if useful. Span lifecycle + cross-cutting axes
   (recoverability, simplicity, maintainability, performance, security, privacy, cost), not just build
   effort. Justify weights (why a criterion dominates).
6. Evaluate with data. Recommend with justification. Steps 7-9 detail the recommended design.
7. Observability -- define what "healthy" means and how it's measured (system and business),
   plus logging, tracing, dashboards, and alarms -- [`observability.md`][observability].
8. Performance & scalability -- load model, latency budget, scaling limits and bottlenecks --
   [`performance.md`][performance].
9. Failure & recovery -- detection, blast radius, recovery paths, and resilience validation
   (fuzz, load/soak, failure injection, game-day) -- [`failure-recovery.md`][failure-recovery].
10. [if: opted in] Cost -- drivers, unit economics, scaling cost, controls; estimate with numbers --
    [`cost.md`][cost].
11. [if: opted in] Operational Readiness -- rollout & migration; accessibility/internationalization
    [if: user-facing] -- [`rollout-migration.md`][rollout-migration], [`accessibility.md`][accessibility].
12. [if: opted in] Security & Privacy -- threat model; privacy assessment [if: personal data];
    compliance [if: regulated] -- [`security.md`][security], [`data-privacy.md`][data-privacy], [`compliance.md`][compliance].
13. Open questions. Anything researchable is researched first and never listed here. Surface only
    questions that need a design decision from the user to clarify direction (preference, priorities,
    org context the agent can't resolve). False certainty compounds into implementation surprises.

## Rules

- Each approach gets full exploration, never dismissal (dismissing = spec behavior)
- Compare across the full lifecycle -- build, operate, recover, maintain, retire.
  Build is the cheapest phase; operation and maintenance dominate total cost of ownership.
  Cheapest to build is often costliest to own.
- Evidence cites a verifiable source -- benchmark numbers, prior art, similar system.
  Unattributed claim = opinion; opinions don't justify resource commitment.
- Quantify comparatives. "Faster/cheaper" -> magnitude, or mark unknown. Vague comparison hides risk.
- Recommendation separate from exploration (readers evaluate independently first)
- Default decision priority: correct > simple > fast. Prefer the correct, simpler design over a
  faster, more complex one unless performance is a stated requirement; override only with explicit justification.
- Observability, performance, and reliability (failure & recovery) are first-class core outputs,
  detailed for the chosen design.
- Decision-shaping posture (cost, performance, security/privacy) stays in the comparison (see Scope);
  the detailed reviews are optional extended scope. Bolt-on security and privacy leak, so offer them up front.
- Open questions first-class (unknowns acknowledged, not hidden)
- Declarative voice. State decisions, not deliberation history (history lives in version control).
- ONE author. Conflicting input -> document both, author recommends.

## Output

Core: `design-{name}.md` -- load [`design-template.md`][design-template]; adapt sections.

Large design only (each approach is itself a sub-design): deep-dive each approach in its own doc from
[`approach-template.md`][approach-template] (`design-{name}-approach-{label}.md`); the core doc
summarizes, compares, and links them. Normal designs keep approaches inline -- no separate docs.

Opted-in reviews (see Scope): add as core-doc sections or load
[`operational-readiness-template.md`][orr-template] / [`security-privacy-template.md`][sp-template].

Calibration -- shallow vs lifecycle-deep examples (the bar): [`calibration.md`][calibration].

Post-design: invoke `architecture-decision-record` for the decision,
`spec-driven-development` for implementation planning.

## Quality

### Core design doc

- [ ] Scope settled up front (which reviews, if any, are in)
- [ ] Problem scope defined without prescribing solution
- [ ] Constraints listed before approaches
- [ ] Each approach scored across the lifecycle (build, operate, recover, maintain, retire)
- [ ] Each approach states cost posture
- [ ] Each approach states performance posture
- [ ] Each approach states security/privacy posture
- [ ] Simplicity compared across approaches (moving parts, failure surface, cognitive load)
- [ ] Recovery compared across approaches, not only the chosen one
- [ ] Evidence attributed to a source
- [ ] Evaluation criteria explicit
- [ ] Criteria span the lifecycle and cross-cutting axes
- [ ] Criteria weights justified
- [ ] Recommendation separable from exploration
- [ ] Observability detailed for the chosen design
- [ ] Performance detailed for the chosen design
- [ ] Failure & recovery detailed for the chosen design
- [ ] No approach dismissed without exploration
- [ ] Open questions acknowledged
- [ ] Declarative voice

### Cost [when in scope]

- [ ] Drivers, unit economics, scaling cost, controls -- estimated with numbers

### Operational Readiness [when in scope]

- [ ] Rollout & migration: strategy, compatibility, data migration/backfill, cutover, rollback
- [ ] Accessibility addressed (or N/A -- not user-facing)
- [ ] Internationalization addressed (or N/A -- not user-facing)

### Security & Privacy [when in scope]

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
- Silent omission of extended reviews. Don't quietly skip cost/rollout/security/privacy -- offer them up
  front so the user decides consciously. An unasked-about blocker is still a blocker.
- Design by committee. Conflicting input -> document both, author recommends.

[design-template]: assets/design-template.md
[approach-template]: assets/approach-template.md
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
