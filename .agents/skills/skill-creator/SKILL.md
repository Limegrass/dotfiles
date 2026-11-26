---
name: skill-creator
description: >
  Creates, revises, reviews, and evaluates agent skills -- SKILL.md plus scripts, references, and
  assets. Use when asked to write or change a skill, diagnose a skill that triggers wrongly or
  misbehaves, audit a skill for outdated prompting patterns, or test a skill against a baseline.
  Distinct from domain-documentation, which documents a codebase for readers, and
  design-document, which compares approaches for a change.
---

# Skill Creator

Create, write, iterate on skills.

## Gather Requirements

| Question                         | Drives                                     |
| :------------------------------- | :----------------------------------------- |
| What task automated?             | Scope                                      |
| When should it trigger?          | `description` field (sole trigger source)  |
| What does agent lack today?      | Prevents redundancy (check current skills) |
| Rule file already covers it?     | Cut rule to trigger + skill name           |
| Global or project-specific?      | File path                                  |
| Needs scripts/references/assets? | Directory structure                        |

Ask the user for unknowns. Never guess scope.

### Baseline

Before writing, run 2-3 realistic prompts in a clean context without the skill (delegate). The
failures are the acceptance criteria; Finalize re-runs the prompts with the skill. No observable
failure -> ask whether the skill is needed. Skip when the user dictates the procedure verbatim.

### Placement

Place the skill directory where the harness discovers skills -- user-global for skills used
everywhere, project-local for skills tied to one repository.

Directory name must match frontmatter `name` exactly.

## Write

### Directory

```
{skill-name}/
  SKILL.md         (required)
  scripts/         (optional: executables)
  references/      (optional: on-demand docs)
  assets/          (optional: templates, resources)
  ...              (optional: any other files or directories)
```

### Progressive Disclosure

Skills load in 3 phases. Design for this:

1. `Metadata` (~100 tokens): `name` + `description` loaded at startup for all skills
2. `Instructions` (<5000 tokens): Full SKILL.md body loaded on activation
3. `Resources` (as needed): files in scripts/, references/, assets/ loaded on demand

Implications:

- Body loads only after the description triggers, so "when to use" text belongs in the
  description.
- Body contains every-activation content. Move conditional/reference content to separate files.
- Body loads once and is not re-read on later turns: phrase guidance to hold for the whole task
  ("after every edit"), not as one-time steps.
- Highest-value content first: harnesses often keep only the start of a skill.
- Split files by retrieval purpose. If agent needs A without B, separate files.
- File references one level deep from SKILL.md. No nested reference chains.
- Use relative paths from skill root: `references/REFERENCE.md`, `scripts/extract.py`
- Conditional loading: "Read `references/X.md` if Y happens" > generic "see references/"

### Starting Skeleton

Adapt freely. Rename sections. Add/remove based on skill's nature.
Not rigid template -- starting point.

```markdown
---
name: [skill-name]
description: >
  [What it does and its main use case, in the first sentence.]
  [When to use: intent categories. Distinct from adjacent skills.]
---

# <Title>

<One-line purpose.>

## Rules [if: hard constraints]

<Constraints, guardrails. Reasons only where judgment applies.>

## Traps [if: domain has non-obvious pitfalls]

<Environment-specific facts that defy reasonable assumptions.
Not generic advice. Concrete corrections to mistakes agent will make.>

## Process

<Steps agent follows. Numbered if sequential, bulleted if heuristic.>

## Output

<Structure produced. Placeholders. Conditional sections marked [if: ...]>

## Variants [if: multiple output formats]

<Format-specific structure.>
```

Structure matches nature:

- Structured output skills -> skeleton/template (e.g., domain-documentation)
- Process skills -> phases/modes (e.g., this one)
- Context/knowledge skills -> rules/constraints only (e.g., code-guidelines)

Process skills load knowledge skills by name at the step that uses them: "Load
`unit-test-standards` first; Phases 2 and 4 use it." Delegates may start without the caller's
skills or rule files, so a delegate prompt names the skill to load or carries its rules.

### Frontmatter Fields

Required:

- `name`: 1-64 chars, lowercase alphanumeric + hyphens, no start/end/consecutive hyphens, must match directory name
- `description`: 1-1024 chars, describes what + when to trigger, include distinguishing keywords

Optional:

- `license`: short license name or reference to bundled file
- `compatibility`: 1-500 chars, environment requirements (runtime, packages, network). Most skills skip this.
- `metadata`: string key-value map for additional properties (author, version, etc.)
- `allowed-tools`: space-separated pre-approved tools (experimental)

No other fields: strict validators and skill uploads reject unknown fields, and harness-specific
fields do not carry across harnesses.

### Description Optimization

Description carries entire triggering burden. Optimize for:

- `Use case first`: the first sentence states what the skill does and its main use case. Many
  skills share one listing budget; harnesses truncate or drop descriptions when it overflows.
- `Voice`: "Does X. Use when Y." -- no I or you.
- `User intent`: describe what the user wants, not internal mechanics.
- `Pushy by category`: name the intent categories that apply, including requests that never
  name the domain. A missed query is evidence about a category, not wording to copy: widen the
  category it belongs to. A few representative phrases are fine; one appended per miss overfits.
- `Boundary`: a "Distinct from" clause naming the adjacent skill, where one competes.
- `Plain text`: no angle brackets or markup.
- `Length`: a few sentences to a short paragraph; hard limit 1024 chars.

Bad: `description: Helps with PDFs.`
Good (illustrative):

```yaml
description: >
  Analyzes CSV and tabular data files -- computes summary statistics, adds
  derived columns, generates charts, and cleans messy data. Use when user has
  a CSV, TSV, or Excel file and wants to explore, transform, or visualize it,
  even without mentioning "CSV" or "analysis".
```

### Principles

1. Every line earns its place: would the agent get this wrong without it? No -> cut. Omit what
   the agent already knows (PDFs, HTTP), drop filler (hedges, pleasantries, restated context),
   and say each thing once -- no repeats between SKILL.md and references/, no auxiliary files
   (README, CHANGELOG). A concern another skill owns gets a pointer naming that skill and stating
   only what differs here. Give a reason only where a rule needs judgment -- it tells the agent
   where the rule stops. Exact rules and obvious benefits need none.
2. Examples over explanations. Behavioral guidance gets 2-3 varied examples labeled
   illustrative -- a single example gets copied in length, tone, and structure. Templates use
   placeholders and mark optional sections `[if: ...]`.
3. Be strict only where it matters. One right order or format -> exact steps and a template;
   many good answers -> principles and constraints.
4. Defaults, not menus. Pick one approach and mention alternatives briefly.
5. Teach the problem class, not the instance. Skills serve many prompts: favor procedures over
   declarations, and don't overfit to test cases.
6. Plain words: state the condition and the action, not a slogan; one term per concept. An agent
   rebuilds a slogan differently each time.

### Effective Patterns

Use patterns that fit skill's nature:

- `Traps section`: concrete corrections to mistakes agent will make without being told
- `Output templates`: more reliable than describing format in prose
- `Checklists`: multi-step workflows with progress tracking
- `Validation loops`: do work -> run validator -> fix -> repeat until pass. Invoke
  `agentic-loop-design` before writing one -- roles, termination, guards, and state are settled
  there rather than per skill
- `Plan-validate-execute`: create plan -> validate against source of truth -> execute

### Quality Check

- [ ] Validator passes: `uvx --from 'git+https://github.com/agentskills/agentskills@83021e2#subdirectory=skills-ref' skills-ref validate <skill-dir>`
- [ ] Description: use case first, user intent, boundary vs adjacent skills, plain text
- [ ] No "when to use" in body (that's description's job)
- [ ] Each line earns its place: needed, said once, no filler, reasons only on rules that need
      judgment
- [ ] Concerns another skill owns: pointer by name, not restated
- [ ] Reference files split by retrieval purpose (not arbitrary size)
- [ ] File references one level deep, relative paths, with conditional triggers
- [ ] Templates use placeholders; behavioral examples varied and labeled illustrative
- [ ] Defaults chosen, alternatives mentioned briefly (not equal menus)
- [ ] Teaches the problem class; nothing overfit to one prompt or test case
- [ ] Plain words: conditions and actions, not slogans; one term per concept
- [ ] Names capabilities (delegate a reviewer, ask the user), not tool names -- tool names differ
      between harnesses
- [ ] Structure matches skill nature (template-producing vs process-guiding)
- [ ] Deterministic processes extracted to scripts/, not prose (one-liners stay inline)

## Finalize

Loop before presenting output. `agentic-loop-design` owns roles, termination, dismissal, guards,
and the ledger; this section states only what is specific to skills.

1. Gate: run the validator (Quality Check). Failures are never dismissable. Validator unavailable
   (offline, no uv) -> report the gate blocked and check name and description by hand; never
   report it passed.
2. Judge: delegate a read-only reviewer the skill directory, Quality Check, and Principles -- plus
   [audit patterns][skill-audit] when revising an existing skill. Findings cite file:line and the
   item violated. No delegation available -> run the checks in place and report them self-judged.
3. Fix or dismiss each finding.
4. Judge clean -> re-run the Baseline prompts once with the skill. A prompt that still fails is a
   finding.
5. Done when the gate passes and zero findings remain actionable.

## Iterate

Entry points: usage feedback, false or missed triggers, bad output, quality review, model change.
Not sequential -- enter at relevant concern.

Read [audit patterns][skill-audit] to review existing skill text: before adding text, on a quality
review, and after the model running your skills changes.

### Process

1. Identify the gap from the signal.
2. Read the current SKILL.md and the references the gap touches.
3. Before adding text, ask whether it would help most prompts or only the one that surfaced it.
   Prefer generalizing or removing an instruction over appending one.
4. Make the minimal change that addresses one concern. Confirm a trigger fix by rerunning
   should-trigger and near-miss prompts, judged on prompts held out from tuning. Small counts prove
   little -- 4 of 5 passing fits a true rate far below 80% -- and new prompts tell more than reruns
   of the same one.
5. Finalize.

## When to Script

Script deterministic processes -- multi-step, fixed input -> fixed output.
Spot it at authoring (process skills), not only after repeated reinvention.

One-liners and single commands stay inline.
Validation/review checks are processes too -- deterministic verification -> script.
A rule that must hold every time belongs in a script, validator, or harness hook.

Division of labor: model selects parameters and interprets results; script owns
deterministic logic. Model reads script internals only when needed.

See [script design guide][skill-scripts] for agentic script patterns.

Key rules for agentic scripts:

- No interactive prompts (agents can't respond to TTY)
- `--help` with flags + examples
- Helpful errors: what went wrong, what expected, what to try
- Structured output (JSON/CSV to stdout, diagnostics to stderr)
- Self-contained deps (PEP 723 for Python, npm: specifiers for Deno)
- Idempotent: "create if not exists" over "create and fail on duplicate"

### Links

- [Agent Skills Spec][agentskills-spec]
- [Best Practices][agentskills-practices]
- [Optimizing Descriptions][agentskills-descriptions]

[skill-audit]: references/audit-patterns.md
[skill-scripts]: references/script-patterns.md
[agentskills-spec]: https://agentskills.io/specification
[agentskills-practices]: https://agentskills.io/skill-creation/best-practices.md
[agentskills-descriptions]: https://agentskills.io/skill-creation/optimizing-descriptions.md
