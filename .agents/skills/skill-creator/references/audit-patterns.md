# Audit Patterns

Find lines written for older models and facts that have since changed. Current models follow text
literally, so an outdated line changes behavior, while merely redundant text costs only tokens. A
match is a candidate, not a finding: judge what the line does before flagging it.

## Patterns

| Pattern | Signal | Fix |
| :-- | :-- | :-- |
| Caps emphasis | MUST/NEVER/ALWAYS/CRITICAL in capitals | Plain statement; a reason only if the rule needs judgment |
| Hedged requirement | "try to", "if possible" on something required | State the requirement; hedges read as permission to skip |
| Prohibition run | Several "do not" lines in a row | Keep those guarding a failure that still happens; restate the rest as what to do |
| Strategy advice | "It's usually best to..." | Delete unless it changes what is allowed or how success is judged |
| Grader talk | "graded on", "hidden tests" | State the requirement the grader checks |
| Stale facts | Paths, flags, versions, skill names | Check against current files; fix or generalize |
| Conflicting skills | Two skills or rule files ruling on one topic differently | One owner; the others point to it |
| Change narration | "now", "no longer", past tense, ticket identifiers | State the current rule; history lives in version control |
| Mixed jobs | One skill doing unrelated jobs | Split it |

## Keep

- Context only the author has, including reasons for rules that need judgment.
- Exact steps where only one sequence is safe.
- A few representative trigger phrases beside the description's intent categories.
- Examples that pin an exact output format.
- Text that names a pattern to warn against it, such as the rows above.

## Verify

Removal is a hypothesis. Check each contested change before and after on a scratch copy, with a
small probe that exercises the instruction's purpose -- asking the agent whether it needs a line
measures nothing. Change one thing at a time when stakes are high. A cut that regresses comes back
in its minimal form, not the original wording.
