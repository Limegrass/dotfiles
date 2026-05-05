---
name: domain-documentation
description: >
  Agent-consumable domain reference for a codebase. Documents WHY (invariants,
  rationale, constraints) and cross-cutting structure (state machines, topology,
  flows). Adapts to service, library, CLI, pipeline, infra, frontend.
  Invoke when asked to document a service, summarize domain logic, create a
  reference guide, onboarding docs, map a codebase, or explain architecture.
---

# Domain Documentation

## Process

1. Identify codebase type (service, library, CLI, pipeline, infra, frontend, hybrid).
2. Read entry points and domain boundaries.
3. Find governing rules: invariants, preconditions, ordering, coupling rationale.
   Example: "Orders must be CONFIRMED before shipment -- enforced in handler, no FK. [order_handler.ts L33](link)"
4. Map decisions: why X over Y? What breaks if changed?
5. Trace causal chains and cross-boundary structure (state machines, topology, flows).
6. Pick sections from skeleton. Consult Type Hints for codebase-specific guidance.
   Omit irrelevant. Add unlisted if needed.
7. Write. Back claims with permalinks (see Rules).

## File Structure

Simple (single bounded context, few processes):

```
domain/{name}.md
```

Medium (multiple processes, single subdomain):

```
domain/{name}/
├── index.md                (overview, architecture rationale, routing)
├── {process-a}.md          (one process/system, self-contained)
├── {process-b}.md
└── {process-c}.md
```

Complex (multiple subdomains, each with distinct processes):

```
domain/{name}/
├── index.md                (top-level routing, architecture rationale)
├── {subdomain-a}/
│   ├── index.md            (subdomain overview, routing to processes)
│   ├── {process-1}.md      (one process, self-contained)
│   └── {process-2}.md
├── {subdomain-b}/
│   ├── index.md
│   └── {process-1}.md
└── {subdomain-c}/
    └── {process-1}.md      (single process = no index needed)
```

Decompose recursively until each leaf file covers one process/system.
Each leaf self-contained: rules, flows, entities, safety relevant to that process.
Folder = subdomain too broad for one file. Index = routing table.

Split criterion: different investigation needs = different files.
Agent investigating one process loads one leaf. No cross-file assembly needed.
Compress until removing more loses navigability.

## Skeleton

Sections are menu. Omit inapplicable. Rename freely.

```markdown
# <Name> Domain Reference

## Purpose

One sentence. Why this exists and what problem it solves.

## Architecture Rationale

Why this structure? What constraints drove design?
Not "we use X" but "we use X because Y, changing to Z breaks W."

## Related Docs

- [<Related>](./path/to/related.md)

## Domain Rules

Core section. Each rule answers: "what breaks if violated?"

1. <Rule: what must hold>
   Why: <consequence of violation>
   [<File> L#-L#](permalink)

## Entity Lifecycles [if: stateful entities]

### <Entity>

| From      | Event     | To        | Guard       | Consequence If Skipped |
| --------- | --------- | --------- | ----------- | ---------------------- |
| <STATE_A> | <trigger> | <STATE_B> | <validator> | <what breaks>          |

Ref: [<File> L#-L#](permalink)

### Cross-Entity Constraints [if: multi-entity invariants]

| Constraint  | Entities | Violation Consequence |
| ----------- | -------- | --------------------- |
| <invariant> | <A, B>   | <what breaks>         |

## Domain Types [if: types with non-obvious business semantics]

Catalog types where name alone doesn't convey meaning.
Enums, status codes, discriminated unions, domain-specific shapes.

| Type       | Values/Shape                | Business Meaning                          | Ref        |
| ---------- | --------------------------- | ----------------------------------------- | ---------- |
| <TypeName> | <enum values or shape desc> | <what each value means in domain context> | [L#](link) |

Constraints between types belong in Domain Rules (e.g., "X status blocks Y operation").

## Entry Points

Adapt columns to codebase type. Include purpose/rationale column.

| <Identifier> | <Trigger/Args> | <Handler/Module> | <Why It Exists> | <Ref> |
| ------------ | -------------- | ---------------- | --------------- | ----- |

Column examples by type:

- Service: Type | Trigger | Handler | Purpose
- Library: Module | Signature | Why Exposed | Ref
- CLI: Command | Args | Purpose | Ref
- Pipeline: Stage | Trigger | Actions | Why This Order | Ref
- Infra: Resource | Type | Purpose | Why This Design | Ref
- Frontend: Route/Component | Props | State | Why This Boundary | Ref

## Validation Boundaries [if: >2 validation layers]

| Boundary | Type                         | What It Prevents      | Ref        |
| -------- | ---------------------------- | --------------------- | ---------- |
| <where>  | <Input/Business/Auth/Schema> | <violation prevented> | [L#](link) |

## Configuration [if: runtime-configurable]

| Parameter | Source            | Why Configurable     | Default | Risk If Wrong  |
| --------- | ----------------- | -------------------- | ------- | -------------- |
| <name>    | <env/file/remote> | <flexibility reason> | <val>   | <failure mode> |

## Safety [if: writes, side effects, or concurrency]

| Operation | Idempotent | Mechanism | Why This Approach |
| --------- | ---------- | --------- | ----------------- |
| <op>      | Yes/No     | <how>     | <rationale>       |

### Failure Modes

| Boundary | Strategy                         | Why      | Partial State Risk |
| -------- | -------------------------------- | -------- | ------------------ |
| <layer>  | <retry/DLQ/propagate/compensate> | <reason> | <what goes wrong>  |

## Data Flow

Why data flows this way. Ordering constraints.
Use invocation-path-format for complex flows.

1. <trigger> -> <handler>. Why: <routing reason>
2. <handler> -> <validator>. Why: <must precede X>
3. <store write>. Why: <consistency requirement>
4. <event publish>. Why: <downstream dependency>

## Extension Points [if: plugin/hook architecture]

| Hook   | Interface | Why Extensible Here | Ref        |
| ------ | --------- | ------------------- | ---------- |
| <name> | <type>    | <rationale>         | [L#](link) |

## Known Failure Modes [if: operational issues documented]

| Symptom      | Root Cause | Why               | Mitigation |
| ------------ | ---------- | ----------------- | ---------- |
| <observable> | <cause>    | <systemic reason> | <fix>      |
```

## Rules

- Every non-trivial claim: permalink with line ranges. Omit for self-evident structural statements.
- Domain Rules = core section. If one survives, this one.
- Column headers encode questions. No prose restating above tables.
- WHY + cross-boundary structure in. Per-file WHAT out.
- No unicode in output.
- Focus: "what breaks if agent changes this without understanding the rule?"

Bad: "UserService has methods create(), delete(), get()."
Good: "User deletion must precede org-membership cleanup because FK cascade
is disabled for audit retention. [user_service.ts L45-L52](link)"

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
