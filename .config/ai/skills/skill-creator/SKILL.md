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
└── assets/          (optional: output files)
```

### Starting Skeleton

Adapt freely. Rename sections. Add/remove based on skill's nature.
Not a rigid template -- a starting point.

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

## Variants [if: multiple output formats]

<Format-specific structure.>

## Rules

<Constraints, guardrails. Each with reasoning.>
```

Skills that produce structured output (like domain-documentation) need
a skeleton/template section. Skills that guide process (like this one)
need phases/modes. Match structure to skill's nature.

### Principles

1. Description = sole trigger source. Front-load trigger phrases.
   Body loads only after trigger fires. No "when to use" in body.
2. Examples over explanations. Show good/bad output when possible.
3. Freedom matches fragility:
   - Fragile/sequential output: prescriptive steps + skeleton
   - Heuristic/creative output: principles + constraints only
4. No redundancy between SKILL.md and references/.
5. No auxiliary files (README, CHANGELOG).
6. Caveman the final output. Kill fluff, keep substance.
7. Reasoning over rigid commands. "Why" > "MUST".
   Exception: hard constraints that genuinely have no flexibility (e.g., directory naming).
8. Generalize. Skills serve many prompts. Don't overfit to test cases.
9. Sections are menu when producing templates. Mark conditional with `[if: ...]`.
10. Split files by retrieval purpose, not arbitrary line count.
    If agent needs section A without section B, they belong in separate files.

### Description Must Answer

- What does it produce?
- What phrases trigger it?
- What distinguishes it from similar skills?

### Calibration Example

Bad skill output (over-rigid, domain-specific, restates obvious):

```markdown
## Rules

- ALWAYS use TypeScript
- NEVER import from relative paths
- You MUST add unit tests for all functions

## When to Use

Use this skill when writing TypeScript code.
```

Good skill output (reasoned, general, actionable):

```markdown
## Rules

- Prefer strict types. `any` hides bugs that surface at runtime.
- Edge cases from code analysis, not imagination. Each traces to code ref.
- "When to Use" belongs in description frontmatter, not body.
```

### Quality Check

- [ ] Directory name = `name` field
- [ ] Description has trigger phrases and distinguishes from similar skills
- [ ] No "when to use" in body (that's description's job)
- [ ] Placeholders, not domain examples
- [ ] Rules have reasoning, not bare imperatives
- [ ] Structure matches skill nature (template-producing vs process-guiding)

## Finalize

Mandatory loop before presenting output:

1. Quality Check. Fix failures.
2. Caveman pass. Strip fluff.
3. Principles check. Fix violations.
4. Repeat until stable.

Never present draft without completing this loop.

## Iterate

Entry points: usage feedback, false triggers, missed triggers, bad output.
Not sequential phases -- enter at the relevant concern.

### Signal -> Fix

| Signal                  | Fix                             |
| ----------------------- | ------------------------------- |
| False trigger           | Narrow description              |
| Missed trigger          | Add phrases to description      |
| Wrong output            | Add constraints to body         |
| Too verbose             | Trim, compress                  |
| Unnecessary questions   | Add defaults                    |
| Body too large          | Extract to references/          |
| Over-rigid output       | Add "adapt freely" escape valve |
| Under-structured output | Add skeleton/template           |

### Process

1. Identify gap from signal
2. Read current SKILL.md
3. Minimal change addressing one concern
4. Verify: description still accurate? Redundancy introduced?
5. Self-review. Repeat 3-4 until stable.

### Anti-Patterns

| Problem                              | Fix                             |
| ------------------------------------ | ------------------------------- |
| "When to Use" in body                | Move to description             |
| Domain-specific examples             | `<placeholders>`                |
| Comments on obvious                  | Remove                          |
| Multiple responsibilities            | Split into separate skills      |
| Script logic in prose                | Move to scripts/                |
| ALWAYS/NEVER/MUST overuse            | Explain reasoning instead       |
| Narrow to test examples              | Generalize the principle        |
| Fixed skeleton for heuristic skill   | Use principles, not rigid steps |
| Redundant statements across sections | Consolidate to one location     |

## When to Script

If same code rewritten >2 times across invocations, move to scripts/.
Scripts: token-efficient, deterministic, execute without loading into context.

## Frontmatter Fields

Required: `name`, `description`
Optional: `license`, `allowed-tools`, `metadata`
No other fields.

## References

- [Agent Skills Spec](https://agentskills.io/specification)
