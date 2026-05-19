---
name: spec-driven-development
description: >
  Produces spec documents before implementation. Invoke when asked to: write a
  spec, spec out a change, plan a feature, define requirements, design an
  approach, or before implementing any feature/fix/refactor.
---

# Spec-Driven Development

## Process

1. Resolve types/schemas involved. Read definitions, search codebase.
   If types unavailable: AskUser.
2. Research current state:
   - Trace invocation paths (`invocation-path` skill). Read source.
   - Query APIs/data if accessible. Capture actual output as evidence.
   - Find existing tests covering the area.
3. If research reveals undocumented system invariants/flows:
   invoke `domain-documentation` for current-state knowledge.
   Spec references resulting doc; plans stay in spec.
4. Identify at least one rejected alternative.
5. Write spec to file. TODOs acceptable -- draft > blocking.
6. Resolve unknowns: search, query, infer. Research first; only mark
   `[TODO: user to provide]` after exhausting available tools.
7. Present for review.

## Rules

- Spec is declarative artifact. No iterative language.
  "Per feedback, changed X" -> just state X. History lives in git.
- Feedback: edit in-place. Add `[Revised: date]` only if substantial change.
- Rejected approach in feedback: archive as `spec-{name}-v1-rejected.md`, start fresh.
- Unresolved disagreement: document both positions, mark `[DECISION NEEDED]`.
- Never delete specs. Superseded specs retain historical context.
- Post-approval in unrestricted mode: delegate `plan-for-correctness`,
  `plan-for-maintainability`, `plan-for-performance` against spec.
  Findings feed back as advisory; spec remains source of truth.

## Output

File: `spec-{ticket-id}.md` or `spec-{feature-slug}.md`

Template: [`spec-template.md`][spec-template]. Adapt sections.

Post-spec: `unit-test-development` against Acceptance Criteria (TDD -- tests before code).

## Calibration

### Bad (vague, unanchored):

> ## Problem
>
> "The API is slow and needs to be faster."
>
> ## Delta
>
> "Improve performance."
>
> ## Edge Cases
>
> "Handle edge cases properly."

Why bad: no code refs, no measurements, no specific behavior change, no evidence.

### Good (anchored, testable):

> ## Problem
>
> `POST /api/orders` returns 500 when `items` array is empty. 43 occurrences in
> last 7 days per CloudWatch Logs Insights query. Clients retry, amplifying load.
>
> ## Acceptance Criteria
>
> - [ ] Empty items array returns 400 with `{"error": "items required", "code": "EMPTY_ITEMS"}`
> - [ ] Existing test suite passes without modification
> - [ ] CloudWatch alarm for 500s on /api/orders drops to 0 within 24h of deploy
>
> ## Current State
>
> Code: [`OrderService.java L44-52`][ref-order-handler] -- iterates `items`
> without empty check. L47 calls `items.get(0)` unconditionally.
>
> ## Delta
>
> | Aspect      | Before             | After                | Why                |
> | :---------- | :----------------- | :------------------- | :----------------- |
> | Empty items | 500 NPE            | 400 structured error | Client-correctable |
> | Retry storm | Clients retry 500s | 400 stops retries    | Reduces load 3x    |
>
> ## Alternatives
>
> Return 200 with empty order -- rejected. Violates domain invariant
> (order must have items). Downstream systems assume non-empty.

## Quality

- [ ] Problem has measurable impact (numbers, not adjectives)
- [ ] Every Acceptance Criterion testable by automation or observation
- [ ] Observability defines specific metric/query (not "add monitoring")
- [ ] Risks separate likelihood from impact
- [ ] Rollback strategy concrete (revert commit, feature flag, etc.)

## Traps

- Inventing code references. Never fabricate file:line links. Exhaust search before marking `[TODO: locate]`.
- Skipping Alternatives. "Only one way" almost never true. Push past first solution.
- Vague Acceptance Criteria. "Should work correctly" not testable. State specific observable behavior.
- Evidence from imagination. Can't query system? Say so. Don't invent JSON responses.
- Copying template prose. Replace ALL placeholder text. `<description>` in output = failure.
- Iterative language in spec. Declarative artifact, not conversation transcript.
- Missing code refs. Every claim about current behavior needs permalink evidence.

[spec-template]: assets/spec-template.md
[ref-order-handler]: permalink
