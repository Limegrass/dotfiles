---
name: plan-for-maintainability
description: >
  Plan implementation focusing on maintainability: simplicity,
  readability, extensibility, code organization. Invoke when
  delegated to analyze changes from maintainability perspective.
---

# Planning for Maintainability

Produce findings and recommendations, not implementations.

## Analysis

For each affected component, evaluate:

1. `Readability`: intent clear without explanation?
   If not, abstraction wrong or naming weak.
2. `Responsibility isolation`: each unit does one thing?
   Mixed concerns signal split point.
3. `Abstraction depth`: indirection without reuse = cost without payoff.
   Prefer flat over deep when call sites few.
4. `Coupling`: changes here force changes elsewhere?
   Measure: "what breaks if I rename/move this?"
5. `Codebase consistency`: follow existing patterns unless actively migrating.
   Inconsistency taxes every future reader.
6. `Simplest solution`: fewer files, types, indirections?
   Complexity must earn its keep.
7. `Testability`: can components be tested in isolation?
   Hidden dependencies (static calls, new in constructor, global state) block this.
   Inject dependencies explicitly.
8. `Change amplification`: one logical change requires edits in N places?
   Signal for missing abstraction or violated DRY at 3+ occurrences.

## Traps

- Refactoring working code you're not changing = net negative.
- 2 occurrences isn't duplication. 3 is pattern. Abstract at 3.
- "Cleaner" without measurable benefit = opinion, not improvement.
- Premature abstraction (interface with 1 impl, no planned second) adds indirection for nothing.
- Inconsistency within module is worse than suboptimal consistency across codebase.
- Utils/Helpers/Common classes = failure to find proper abstraction boundary. Name the concept.
- Comments explaining "what" instead of "why" = sign code isn't self-documenting. Fix the code.
- Deep inheritance hierarchies for code reuse -- prefer composition. Inheritance = "is-a" only.

## Scope

Deprioritize: working code with stable interfaces, tactical duplication (2x), performance paths sacrificing readability deliberately.

Prioritize: public interfaces, frequently-modified code, team-shared modules.

## Output

```markdown
### Maintainability Analysis

#### Findings
<What's tangled, where (file:line or module), impact on future changes>

#### Proposed Changes
<File + code-level changes. Before/after structure.>

#### Naming & Structure Suggestions
<Renames, splits, or reorganizations improving discoverability.>

#### Trade-offs
<Cost to performance or short-term effort.>
```

## Calibration

Bad:
> "Consider breaking this into smaller functions for better readability."

Good:
> "`handleRequest()` at ApiHandler.java:30 mixes auth validation (L32-45),
> business logic (L47-80), and response formatting (L82-95).
> Split into: `validateAuth(request)`, `processBusinessLogic(validated)`,
> `formatResponse(result)`. Each becomes independently testable.
> Future auth changes won't risk breaking response format."
