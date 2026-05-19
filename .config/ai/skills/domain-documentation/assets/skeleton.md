# <Name> Domain Reference

## Purpose

One sentence. Why this exists and what problem it solves.

## Architecture Rationale

Why this structure? What constraints drove design?
Not "we use X" but "we use X because Y, changing to Z breaks W."

## Related Docs

- [Related doc name][related-auth-design]

## Domain Rules

Core section. Each rule answers: "what breaks if violated?"

1. <Rule: what must hold>
   Why: <consequence of violation>
   [source][rule-fk-cascade]

## Entity Lifecycles [if: stateful entities]

### <Entity>

| From      | Event     | To        | Guard       | Consequence If Skipped |
| --------- | --------- | --------- | ----------- | ---------------------- |
| <STATE_A> | <trigger> | <STATE_B> | <validator> | <what breaks>          |

Ref: [source][lifecycle-user-states]

### Cross-Entity Constraints [if: multi-entity invariants]

| Constraint  | Entities | Violation Consequence |
| ----------- | -------- | --------------------- |
| <invariant> | <A, B>   | <what breaks>         |

## Domain Types [if: types with non-obvious business semantics]

Catalog types where name alone doesn't convey meaning.

| Type       | Values/Shape                | Business Meaning                          | Ref                   |
| ---------- | --------------------------- | ----------------------------------------- | --------------------- |
| <TypeName> | <enum values or shape desc> | <what each value means in domain context> | [ref][type-role-enum] |

Constraints between types belong in Domain Rules.

## Entry Points

Adapt columns to codebase type. Include purpose/rationale column.

| <Identifier> | <Trigger/Args> | <Handler/Module> | <Why It Exists> | Ref                    |
| ------------ | -------------- | ---------------- | --------------- | ---------------------- |
| <name>       | <trigger>      | <handler>        | <reason>        | [ref][ent-create-user] |

Column examples by type:

- Service: Type | Trigger | Handler | Purpose
- Library: Module | Signature | Why Exposed | Ref
- CLI: Command | Args | Purpose | Ref
- Pipeline: Stage | Trigger | Actions | Why This Order | Ref
- Infra: Resource | Type | Purpose | Why This Design | Ref
- Frontend: Route/Component | Props | State | Why This Boundary | Ref

## Validation Boundaries [if: >2 validation layers]

| Boundary | Type                         | What It Prevents      | Ref                     |
| -------- | ---------------------------- | --------------------- | ----------------------- |
| <where>  | <Input/Business/Auth/Schema> | <violation prevented> | [ref][val-input-schema] |

## Configuration [if: runtime-configurable]

### <parameter>

Source: <env/file/remote>
Default: <val>
Why configurable: <flexibility reason>
Risk if wrong: <failure mode>

## Safety [if: writes, side effects, or concurrency]

### <operation>

Idempotent: Yes/No
Mechanism: <how>
Why this approach: <rationale>

### Failure Modes

### <boundary>

Strategy: <retry/DLQ/propagate/compensate>
Why: <reason>
Partial state risk: <what goes wrong>

## Data Flow

Why data flows this way. Ordering constraints.
Use invocation-path-format for complex flows.

1. <trigger> -> <handler>. Why: <routing reason>
2. <handler> -> <validator>. Why: <must precede X>
3. <store write>. Why: <consistency requirement>
4. <event publish>. Why: <downstream dependency>

## Extension Points [if: plugin/hook architecture]

### <hook>

Interface: <type>
Why extensible here: <rationale>
Ref: [source][ext-auth-hook]

## Known Failure Modes [if: operational issues documented]

### <symptom>

Root cause: <cause>
Why: <systemic reason>
Mitigation: <fix>

[related-auth-design]: ./path/to/related.md
[rule-fk-cascade]: https://github.com/<org>/<repo>/blob/<commit>/<path>#L1-L5
[lifecycle-user-states]: https://github.com/<org>/<repo>/blob/<commit>/<path>#L10-L20
[type-role-enum]: https://github.com/<org>/<repo>/blob/<commit>/<path>#L30
[ent-create-user]: https://github.com/<org>/<repo>/blob/<commit>/<path>#L40
[val-input-schema]: https://github.com/<org>/<repo>/blob/<commit>/<path>#L50
[ext-auth-hook]: https://github.com/<org>/<repo>/blob/<commit>/<path>#L60
