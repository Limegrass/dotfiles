---
name: commit-message
description: >
  Write the commit message before the work it describes, in Conventional Commits form, carrying the
  problem and the reasoning rather than the mechanics. Use when writing or amending a commit
  message, splitting work into commits, or committing. Triggers on "write the commit message",
  "commit this", "amend the message", "how should this split up".
---

# Commit Message

Reader: a maintainer months later inside `git log`, `git blame`, or `git bisect`. Reads through a narrow window -- a line spent on status is a line the reasoning does not get.

Questions gate sections rather than being fields to fill: a change with no defect introduced has no `fixes:` trailer, and inventing one to look complete is the defect these questions exist to prevent. An artifact that cannot answer a question its reader will ask is either missing something or describing work that is not ready.

## Drafting

Draft before the work. The draft bounds scope: work it does not describe belongs to a later commit, and the draft never grows to absorb what the work picked up. Reconcile against `git diff --cached` before committing.

## Title

Follow the [Conventional Commits standard][conventional-commits]. Use imperative voice. Do not capitalize the first letter of the subject. A subject that needs "and" is two commits -- the `Can I read this history at all` question: one logical change per commit, so blame, log, and bisect each return something meaningful rather than a commit doing four things.

```
docs(ai): add commit format template
```

## Body

Answers `Why was this motivated` -- the reason the change was made, which the code cannot state -- and `Does the message match what the code does` -- a mismatch sends a debugger down the wrong path, and costs more than no message at all.

### Do

- Elaborate on the title
- State the problem and the observable that shows it
- Name the approach taken and why it wins over the alternative
- Motivate decisions with data

### Don't

- Do not describe the mechanics
  - the code is authoritative
- Do not describe rollback procedures
  - `review-description` owns those
- Do not restate what the pipeline or the diff reports
  - build green, tests passing, coverage delta, lint clean, lines or files changed
  - the run carries that per revision; a sentence about it is stale on the next push
- Do not describe follow-ups
- Do not describe migrations

```
The freeform commit messages of agents tend to provide
too much information that does not belong in a commit message.
This change provides structure to avoid expanding the scope of the commit message too much.
```

A body that will not write means the motivation is not found yet. Find it before coding.

### Refactor-Only Declaration

A diff that looks behavioural and is not costs the reader a full read -- the `Is this refactor-only` question. State it outright at the end of the body, above the blank line before trailers:

```
No functional change intended.
```

## Trailers

Answers `Where is the ticket` -- traceability for audit and for the next reader -- and `Which commit introduced the defect this fixes` -- named, so a bisect landing on the fix reaches the cause.

Trailers belong at the end, after a blank line. Each trailer is `Token: value` where the token matches `[A-Za-z0-9-]+`. Any line in the block that fails this form -- a token containing a space, for instance -- voids the entire block and silently drops every trailer in it.

The trailer block travels verbatim into the review description. Reproducing the trailers removes a layer of indirection: the reviewer has the links in front of them instead of following a hop to find them.

Verify with `git interpret-trailers --parse`.

### Fixes Reference

A fix names the commit that introduced the defect, so a bisect landing on the fix can reach the cause:

```
fixes: abc1234 (auth: add session cookie check)
```

### Other Trailers

Supplemental links, data, or metadata. Prefer URLs as trailers rather than inline in the body. Examples: issue links, a document, an RFC, a published standard.

```
issue: XYZ-1234
ref: https://www.conventionalcommits.org
```

## Judge

Before using the message, delegate a read-only judge scoring it against:

1. The questions each section names -- each question either answered or inapplicable
2. This skill's bars -- no pipeline-reported facts, no mechanics, no follow-ups

Defer loop mechanics to `agentic-loop-design`. Terminate on actionable count reaching zero, not on judgement.

The judge runs once on the set of commits under review, not per commit. Per-commit judging makes routine work expensive and gets skipped.

## Instruction Text

Instruction text stays out of the message file. `git commit -F <path>` cleans only whitespace by default, so `#` lines survive into the commit.

[conventional-commits]: https://www.conventionalcommits.org/
