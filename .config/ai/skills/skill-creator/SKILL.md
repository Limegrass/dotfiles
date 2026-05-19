---
name: skill-creator
description: >
  Create, update, review, or iterate on Wasabi skills from feedback.
  Invoke when asked to: create a skill, improve a skill, review skill
  quality, fix a skill that isn't triggering, or write a SKILL.md.
  Covers authoring, bundling resources, and feedback-driven iteration.
---

# Skill Creator

Create, write, iterate on skills.

## Gather Requirements

| Question                         | Drives                                     |
| -------------------------------- | ------------------------------------------ |
| What task automated?             | Scope                                      |
| When should it trigger?          | `description` field (sole trigger source)  |
| What does agent lack today?      | Prevents redundancy (check via SkillsTool) |
| Global or project-specific?      | File path                                  |
| Needs scripts/references/assets? | Directory structure                        |

AskUser for unknowns. Never guess scope.

### Placement

- Global: `~/.ees-interactive-repl/skills/{name}/SKILL.md`
- Project: `.config/ai/skills/{name}/SKILL.md` or `wasabi-toolbag/skills/{name}/SKILL.md`

Directory name must match frontmatter `name` exactly.

## Write

### Directory

```
{skill-name}/
├── SKILL.md         (required)
├── scripts/         (optional: executables)
├── references/      (optional: on-demand docs)
└── assets/          (optional: templates, resources)
```

### Progressive Disclosure

Skills load in 3 phases. Design for this:

1. `Metadata` (~100 tokens): `name` + `description` loaded at startup for all skills
2. `Instructions` (<5000 tokens): Full SKILL.md body loaded on activation
3. `Resources` (as needed): files in scripts/, references/, assets/ loaded on demand

Implications:

- Body contains every-activation content. Move conditional/reference content to separate files.
- Split files by retrieval purpose. If agent needs A without B, separate files.
- File references one level deep from SKILL.md. No nested reference chains.
- Use relative paths from skill root: `references/REFERENCE.md`, `scripts/extract.py`
- Conditional loading: "Read `references/X.md` if Y happens" > generic "see references/"

### Starting Skeleton

Adapt freely. Rename sections. Add/remove based on skill's nature.
Not rigid template -- starting point.

```markdown
---
name: <skill-name>
description: >
  <What it produces. 1-2 sentences.>
  <Trigger phrases. When to invoke.>
---

# <Title>

<One-line purpose.>

## Process

<Steps agent follows. Numbered if sequential, bulleted if heuristic.>

## Output

<Structure produced. Placeholders. Conditional sections marked [if: ...]>

## Traps [if: domain has non-obvious pitfalls]

<Environment-specific facts that defy reasonable assumptions.
Not generic advice. Concrete corrections to mistakes agent will make.>

## Variants [if: multiple output formats]

<Format-specific structure.>

## Rules

<Constraints, guardrails. Each with reasoning.>
```

Structure matches nature:

- Structured output skills -> skeleton/template (e.g., domain-documentation)
- Process skills -> phases/modes (e.g., this one)
- Context/knowledge skills -> rules/constraints only (e.g., coding-standards)

### Frontmatter Fields

Required:

- `name`: 1-64 chars, lowercase alphanumeric + hyphens, no start/end/consecutive hyphens, must match directory name
- `description`: 1-1024 chars, describes what + when to trigger, include distinguishing keywords

Optional:

- `license`: short license name or reference to bundled file
- `compatibility`: 1-500 chars, environment requirements (runtime, packages, network). Most skills skip this.
- `metadata`: string key-value map for additional properties (author, version, etc.)
- `allowed-tools`: space-separated pre-approved tools (experimental)

No other fields.

### Description Optimization

Description carries entire triggering burden. Optimize for:

1. **Imperative phrasing**: "Use when..." not "This skill does..."
2. **User intent over implementation**: describe what user wants, not internal mechanics
3. **Be pushy**: explicitly list contexts, including where user doesn't name domain directly
4. **Distinguish from adjacent**: what separates this skill from similar capabilities?
5. **Concise**: few sentences to short paragraph. Hard limit 1024 chars.

Bad: `description: Helps with PDFs.`
Good:

```yaml
description: >
  Analyze CSV and tabular data files -- compute summary statistics,
  add derived columns, generate charts, and clean messy data. Use when
  user has CSV, TSV, or Excel file and wants to explore, transform, or
  visualize data, even without explicitly mentioning "CSV" or "analysis."
```

### Principles

1. Description = sole trigger source. Front-load trigger phrases.
   Body loads only after trigger fires. No "when to use" in body.
2. Progressive disclosure drives structure. Body = concise instructions.
   Detailed docs, examples, lookup tables -> references/. Executable logic -> scripts/.
3. Body = content needed every activation. Conditional content -> references/.
   Gate: "Would agent get this wrong without this instruction?" If no, cut or move to references/.
4. Add what agent lacks, omit what it knows. No explaining PDFs, HTTP, etc.
   Ask: "Would agent get this wrong without this instruction?" If no, cut it.
5. Examples over explanations. Show good/bad output when possible.
6. Freedom matches fragility:
   - Fragile/sequential output: prescriptive steps + skeleton
   - Heuristic/creative output: principles + constraints only
7. Provide defaults, not menus. Menus paralyze agent decision-making.
   Pick one approach; mention alternatives briefly.
8. Favor procedures over declarations. Teach how to approach problem classes,
   not what to produce for specific instance.
9. Traps = highest-value content. Environment-specific facts that defy assumptions.
   Keep in SKILL.md where agent reads them before encountering situation.
10. No redundancy between SKILL.md and references/.
11. No auxiliary files (README, CHANGELOG).
12. Caveman the final output.
13. Reasoning over rigid commands. "Why" > "MUST".
    Exception: hard constraints with no flexibility (e.g., directory naming).
14. Generalize. Skills serve many prompts. Don't overfit to test cases.
15. Sections are menu when producing templates. Mark conditional with `[if: ...]`.
16. File references one level deep. Relative paths from skill root.

### Effective Patterns

Use patterns that fit skill's nature:

- `Traps section`: concrete corrections to mistakes agent will make without being told
- `Output templates`: more reliable than describing format in prose
- `Checklists`: multi-step workflows with progress tracking
- `Validation loops`: do work -> run validator -> fix -> repeat until pass
- `Plan-validate-execute`: create plan -> validate against source of truth -> execute

### Quality Check

- [ ] Directory name = `name` field
- [ ] `name` field: lowercase, alphanumeric + hyphens only, no start/end/double hyphens
- [ ] Description: imperative phrasing, user intent, distinguishes from similar skills
- [ ] No "when to use" in body (that's description's job)
- [ ] Body = every-activation content only. Each line passes "would agent get wrong without this?"
- [ ] No explaining what agent already knows
- [ ] Reference files split by retrieval purpose (not arbitrary size)
- [ ] File references one level deep, relative paths, with conditional triggers
- [ ] Placeholders, not domain examples
- [ ] Rules have reasoning, not bare imperatives
- [ ] Defaults chosen, alternatives mentioned briefly (not equal menus)
- [ ] Structure matches skill nature (template-producing vs process-guiding)

## Finalize

Mandatory loop before presenting output:

1. Quality Check. Fix failures.
2. Caveman pass. Strip fluff.
3. Principles check. Fix violations.
4. Repeat until stable.

## Iterate

Entry points: usage feedback, false triggers, missed triggers, bad output.
Not sequential -- enter at relevant concern.

See [iteration guide][skill-iteration] when diagnosing trigger/output issues.
See [eval guide][skill-eval] if systematic eval-driven iteration needed.

### Process

1. Identify gap from signal
2. Read current SKILL.md
3. Minimal change addressing one concern
4. Verify: description still accurate? Redundancy introduced?
5. Self-review. Repeat 3-4 until stable.

## When to Script

If same code rewritten >2 times across invocations, move to scripts/.
Scripts: token-efficient, deterministic, execute without loading into context.

See [script design guide][skill-scripts] for agentic script patterns.

Key rules for agentic scripts:

- No interactive prompts (agents can't respond to TTY)
- `--help` with flags + examples (primary interface discovery)
- Helpful errors: what went wrong, what expected, what to try
- Structured output (JSON/CSV to stdout, diagnostics to stderr)
- Self-contained deps (PEP 723 for Python, npm: specifiers for Deno)
- Idempotent: "create if not exists" over "create and fail on duplicate"

### Links

- [Agent Skills Spec][agentskills-spec]
- [Best Practices][agentskills-practices]
- [Optimizing Descriptions][agentskills-descriptions]

[skill-iteration]: references/iteration-guide.md
[skill-eval]: references/eval-guide.md
[skill-scripts]: references/script-patterns.md
[agentskills-spec]: https://agentskills.io/specification
[agentskills-practices]: https://agentskills.io/skill-creation/best-practices.md
[agentskills-descriptions]: https://agentskills.io/skill-creation/optimizing-descriptions.md
