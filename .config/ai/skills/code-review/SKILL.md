---
name: code-review
description: >
  Review a diff against a personal rule set -- conventional commits and single responsibility, opaque
  naming and vocabulary, comment signal, type modeling, constructor injection, personal data in logs,
  metrics instrumentation, and hand-rolled reimplementation of library functionality. Use when asked
  to review changes, review a diff, review staged work, review a pull request or code review, run a
  pre-commit or pre-push pass, self-review before publishing, or check work against review standards.
  Also triggers on "review my changes", "look over this diff", "anything wrong with this change",
  "ready to push?".
---

# Code Review

Apply the rule set to a diff. One sub-agent per rule; findings aggregate in the main context, rule
text and line-by-line scanning do not.

## Process

1. Establish the review surface: staged work (`git diff --cached`), working tree (`git diff`), or a
   commit range (`git diff <base>..<head>`). Ask when ambiguous -- reviewing the wrong surface
   invalidates every finding.
2. Record the two commands every rule needs: the diff command for that surface, and
   `git log <range> --format=%B` for the commit messages. Commit hygiene reads the messages, and
   several rules read change purpose from them.
3. List `references/rules/` -- one file per rule, each name stating that rule's position. That listing
   is the rule set; nothing in this file enumerates it, so a rule file that lands is live immediately.
4. Select the rules the change plausibly implicates from those names. Selection is a judgement call on
   what the change does, not a path or extension match; each rule states the conditions under which it
   fires, so delegate it when in doubt and let it decide.
5. Delegate one sub-agent per selected rule, in parallel and read-only, using the prompt template
   below. Do not read rule files in this context.
6. Aggregate returned findings into the output shape verbatim. Do not re-judge, merge, or reword them
   -- the sub-agent held the evidence, this context does not.

## Delegation

One rule per sub-agent. A single agent carrying several rules degrades on the later ones, and a
rejected finding costs the whole batch.

```
Review <surface description> against one rule.

Read, in this order:
1. <skill root>/SKILL.md -- the `Review Discipline` section only.
2. <skill root>/references/rules/<rule file> -- the rule.

Then read the change: `<diff command>` and `git log <range> --format=%B`.

Report in the `Output` shape SKILL.md defines. Before returning a finding, re-judge it against the
rule file's `Do NOT flag` section using only the evidence you would quote; drop whatever that
section exempts. Return the rule name and what was scanned when nothing survives.
```

## Review Discipline

Binds every rule. Rule files do not restate it.

- Positive, diff-visible evidence or no finding. Absence of something (a metric, an enum, a
  redaction) is a finding only where the diff itself shows the need.
- Added and changed lines only. Code the change did not touch stays untouched -- demanding an edit
  there grows the change past its purpose and breaks single-responsibility, which a rule then flags.
- Every finding names the exact change: the replacement snippet, the rename, the call to add.
  Restating a problem without a remedy is noise.
- No praise. Compliance needs no comment.
- One concern per finding, anchored to a specific `file:line` in the diff.
- Intent gates read the commit message plus the diff's dominant added content. Several rules fire
  only where building or reshaping the thing is what the change sets out to do; judging from the
  diff alone over-flags incidental touches.
- "Nothing emits or enforces this" claims need the call chain in the diff checked first. A delegated
  method, shared emitter, or wrapper frequently already covers it, and a second one is a defect.
- Rules are language-agnostic and carry no file-type restrictions. Judge applicability from what the
  changed code does, then name the construct that file's language provides -- not the one an example
  in the rule file happens to use.
- A rule's examples are illustrations, never a closed list. Apply the stated test.
- Advisory by default. Reserve blocking for the unrecoverable -- a secret or personal data that
  cannot be purged once published.

## Output

```
## Findings

### <file>:<line> -- <rule name>

Violation: <what the rule forbids, one line>
Evidence: <quoted added line(s)>
Remedy: <the specific edit>

## Clean [if: no findings]

<rules checked and what each scanned, so the pass is replicable>
```

## Traps

- Findings arrive already validated against their rule. Summarizing or re-deriving them in this
  context reintroduces the rule text the delegation exists to keep out.
- A sub-agent given no commit messages silently skips the intent gates and returns over-flagged
  results. Pass both commands, always.
- An observation with no rule behind it is opinion. Label it as such, apart from findings, so
  mandate stays distinguishable.
- A finding is labelled with its rule file's name, so a name that states the rule's position is what
  makes the report readable. A new rule earns its place by landing a well-named file in
  `references/rules/` -- never by an entry added here.
