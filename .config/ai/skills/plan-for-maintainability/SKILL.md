---
name: plan-for-maintainability
description: >
  Guides implementation planning from a maintainability perspective.
  Invoke when delegated to plan changes focusing on simplicity,
  readability, extensibility, and code organization.
---

# Planning for Maintainability

Analysis and recommendations only. No modifications.

## Analysis

Non-exhaustive. Explore beyond these when context warrants.
For each affected component, evaluate:

1. `Readability`: can a new reader understand intent without explanation?
   If not, abstraction is wrong or naming is weak.
2. `Responsibility isolation`: does each unit do one thing?
   Mixed concerns signal a split point.
3. `Abstraction depth`: indirection without reuse is cost without payoff.
   Prefer flat over deep when call sites are few.
4. `Coupling`: changes here force changes elsewhere?
   Measure: "what breaks if I rename/move this?"
5. `Codebase consistency`: follow existing patterns unless actively migrating.
   Inconsistency taxes every future reader.
6. `Simplest solution`: can this be done with less? Fewer files, types,
   indirections? Complexity must earn its keep.

## Red Flags

- Premature abstraction (interface with one implementation, no planned second)
- God functions mixing I/O, logic, and formatting
- Inconsistent patterns within same module/package
- Changes requiring N call-site updates for future modifications
- Deep inheritance where composition suffices

## Scope Boundaries

Accept:

- Working code with stable interfaces (don't rewrite for style)
- Tactical duplication (2 occurrences) over premature DRY
- Performance-critical paths that sacrifice readability deliberately

Prioritize: public interfaces, frequently-modified code, team-shared modules.

## Output

```markdown
### Maintainability Analysis

#### Findings

<What's tangled, where (file:line or module), impact on future changes>

#### Proposed Changes

<File + code-level changes. Before/after structure.
Each explains WHY it improves long-term maintainability.>

#### Naming & Structure Suggestions

<Renames, splits, or reorganizations improving discoverability.>

#### Trade-offs

<Cost to performance or short-term effort. Be specific.>
```

## Calibration

Bad (generic advice):

> "Consider breaking this into smaller functions for better readability."

Good (specific, reasoned):

> "`handleRequest()` at ApiHandler.java:30 mixes auth validation (L32-45),
> business logic (L47-80), and response formatting (L82-95).
> Split into: `validateAuth(request)`, `processBusinessLogic(validated)`,
> `formatResponse(result)`. Each becomes independently testable.
> Future auth changes won't risk breaking response format."
