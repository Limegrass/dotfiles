---
name: domain-documentation
description: >
  Create agent-consumable domain references for codebases. Document WHY
  (invariants, rationale, constraints) and cross-cutting structure (state
  machines, topology, flows). Adapt to service, library, CLI, pipeline,
  infra, frontend. Invoke when asked to document a service, summarize
  domain logic, create a reference guide, onboarding docs, map a codebase,
  explain architecture, write domain docs, or produce a "how does this work"
  guide for engineers.
---

# Domain Documentation

## Process

1. Identify codebase type (service, library, CLI, pipeline, infra, frontend, hybrid).
2. Read entry points and domain boundaries.
3. Find governing rules: invariants, preconditions, ordering, coupling rationale.
   Bad: "UserService has methods create(), delete(), get()."
   Good: "User deletion must precede org-membership cleanup because FK cascade
   is disabled for audit retention. [user_service.ts L45-L52][ref]"
4. Map decisions: why X over Y? What breaks if changed?
5. Trace causal chains and cross-boundary structure (state machines, topology, flows).
6. Pick sections from Skeleton. Consult Type Hints for codebase-specific guidance.
   Omit irrelevant. Add unlisted if needed.
7. Resolve gaps: search code, trace references, infer from context.
   Present uncertain findings for confirmation. Leave blank only after exhausting research.
8. Write.

## Rules

- Every non-trivial claim: permalink with line ranges.
  Why: docs without anchors decay silently. Permalinks enable validation.
- Document WHY + cross-boundary structure. Exclude per-file WHAT.
  Why: agent reads code for WHAT. Only human context (design decisions, constraints) needs documenting.
- Domain Rules = core section. If one section survives, this one.
  Why: rules are the invisible knowledge most dangerous to violate unknowingly.
- Every domain rule must state "what breaks if violated."
  Why: without consequence, agent cannot assess risk of changes.
- Tables for structured data with short values. Long explanations (Why, Risk) use headings.
  Why: tables with long cells break readability; headings scale to explanation length.
- No unicode beyond natural language in output.
  Why: renders inconsistently across terminals, breaks grep, adds no information.
- One file per investigation path. Split when retrieval needs diverge.
  Why: agent investigating one process shouldn't load entire domain.
- Document boundaries and contracts, not implementation internals.
  Why: internals change with refactors; boundaries change with design decisions.
- Document current state only. Exclude: plans, TODOs, migration alternatives, desired state, action items.
  Why: domain docs answer "how does this work now?" -- aspirational content decays when plans change and confuses what's real.
- Declarative voice only. No iterative/conversational language.
  Why: "After investigating, we found..." decays into inaccuracy. State facts directly. History lives in git.
- Output file structure maps to investigation paths, not source directory layout.
  Why: consumers navigate by question ("how does X work?"), not by folder.

## File Placement

1. Identify the repository's documentation root (e.g. `docs/`, `doc/`, repo root).
2. Place `domain/` folder there.

Within `domain/`, scale structure to content:

```
domain/{name}.md                          -- single process
domain/{name}/index.md + {process}.md     -- multiple processes
domain/{name}/{subdomain}/{process}.md    -- multiple subdomains
```

Each leaf file self-contained. Compress until removing more loses navigability.

## Skeleton

Load [skeleton][skeleton]. Sections are menu. Omit inapplicable. Rename freely.

## Type Hints

| Type     | Likely                          | Rarely                   |
| -------- | ------------------------------- | ------------------------ |
| Service  | All                             | Extension Points         |
| Library  | Rules, Entry Points, Extensions | Safety, Lifecycles       |
| CLI      | Entry Points, Config, Data Flow | Lifecycles, Validation   |
| Pipeline | Data Flow, Config, Safety       | Entry Points, Extensions |
| Infra    | Config, Rules, Known Failures   | Lifecycles, Validation   |
| Frontend | Entry Points, Data Flow, Config | Safety, Lifecycles       |

## Quality

- [ ] Non-trivial claims have permalink
- [ ] Domain Rules explain violation consequences
- [ ] Entry point format matches codebase type
- [ ] Each file serves one retrieval purpose
- [ ] Empty sections omitted
- [ ] Agent unfamiliar with codebase can make safe changes from this doc
- [ ] No WHAT-only content (method lists, file trees without rationale)

[skeleton]: assets/skeleton.md
