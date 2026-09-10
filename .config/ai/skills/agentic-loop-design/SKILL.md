---
name: agentic-loop-design
description: >
  Design patterns for agentic iteration loops -- actor/judge separation, observable
  termination, fingerprints, dismissal authority, guards, and state persistence.
  Use when designing an agentic loop, "iterate until", "loop until clean", choosing
  termination criteria, delegate review loops, or authoring a skill that contains
  a loop. Knowledge/reference skill; invoke by name from procedure skills.
---

# Agentic Loop Design

Patterns for loops that iterate toward a measurable terminal state.

## Concepts

`Actor`: agent that produces work (writes, fixes, creates)
`Judge`: agent that evaluates work against criteria (observes, reports findings)
`Finding`: defect or violation surfaced by the judge
`Fingerprint`: stable identifier for a finding across cycles
`Actionable count`: findings raised minus findings dismissed
`Ledger`: loop state persisted outside context -- cycle count, fingerprints, dismissals
`Cycle`: one iteration of produce -> evaluate -> decide

## Role Separation

Actor and judge run in separate contexts. One agent holding both roles rationalizes
its own work -- the same context that wrote the code explains away its defects.

Actor: writes, fixes, creates. Has edit capability.
Judge: observes in read-only mode, fresh context. No memory of producing the work.

Delegation enforces the boundary. The judge delegate receives the artifact, not the
reasoning that produced it. The code-review skill demonstrates per-rule delegate
passes where findings aggregate without re-judgment.

## Observable Termination

Loops terminate on actionable count reaching zero, never "looks good" or "seems
complete". Judgement is elastic; a count is not.

Actionable = raised - dismissed. The judge determines what is raised. The actor
determines what is dismissed (with recorded reason). Termination occurs when both
agree: no findings, or all findings dismissed.

A termination check that requires reading the work and deciding "good enough" will
plateau at the judge's confidence threshold, which drifts. A count reaches zero or
does not.

## Fingerprints

A fingerprint identifies a finding across cycles so progress is measurable. Without
stable identity, the loop cannot distinguish "same finding, not fixed" from "new
finding introduced by the fix".

Components vary by domain: file + line + rule, test name + error, lint code + location.
The fingerprint must survive reformatting and unrelated changes elsewhere.

Store fingerprints in the state ledger. The no-progress guard compares consecutive
cycles' fingerprint sets.

## Dismissal Authority

Actor dismisses findings the judge raised incorrectly or that represent intentional
trade-offs. Each dismissal records a reason quoting the judge's own exemption clause
or stating why the finding does not apply.

Without dismissal authority, a disputed finding blocks termination forever -- the
judge keeps raising it, the actor keeps disagreeing, the loop never exits. The
actor breaks the tie with an auditable decision.

Dismissal is not "fix by ignoring". The final report lists all dismissals with
reasons. A pattern of dismissals against a rule signals the rule needs revision.

## Guards

Every loop has guards that force exit before runaway:

`No-progress guard`: identical actionable fingerprints two consecutive cycles.
The actor cannot fix what the judge keeps raising. Exit with the disputed set for
manual follow-up.

`Max cycles`: cap on iterations (10 is typical). Exit with remaining findings
listed.

`Wall clock`: timeout on elapsed time. Long-running analysis or slow external
services should not hang indefinitely.

Every guard exit reports the unresolved set so a human can continue. A guard that
silently exits hides the work left undone.

## State Outside Context

Context compacts. A ledger stored only in context disappears when the window
slides.

Persist loop state to an untracked file:

- Current iteration count
- Session/run identifiers
- Fingerprints from previous cycle (for no-progress check)
- Dismissed finding IDs with reasons
- Cumulative fix history

Read at cycle start, write at cycle end. The no-progress check spans cycles and
needs the previous cycle's fingerprints, which context compaction would erase.

## Mechanical Gate

Pair judgement with a mechanical check. Judgement plateaus; a build or test result
does not.

Judgement-only loop: judge decides "clean" -> done. But the judge may accept code
that does not compile or tests that do not pass.

Mechanical gate: build succeeds AND tests pass AND judge reports zero actionable.
The build/test result is binary and not subject to interpretation.

The terminating cycle needs both: judge clean (zero actionable) and mechanical
clean (build/tests pass).

## Narrow Re-Observation

Re-run the checks that fired in the previous cycle, plus those newly implicated by
the fix. Full re-observation is expensive and mostly redundant.

Exception: the terminating cycle (zero actionable expected) needs a full clean pass
to confirm nothing was missed and no new issues introduced.

Narrow scope assumes the fix did not introduce new failures in unrelated checks.
The final full pass catches that assumption when it fails.

## Write-Delegate Preconditions

Delegated write operations require:

`Edit auto-accept`: without it, each edit prompts for confirmation and the loop
stalls waiting for human input.

`File-disjoint grouping`: multiple delegates editing the same file race. Group
related findings by file; one delegate per file group.

Sub-agents return status (fixed, dismissed-with-reason, blocked). Blocked findings
escalate to the main context for manual handling.

## Anti-Patterns

`Loop with no counter`: no max-iterations guard; runs forever on stuck analysis.

`Judge that also fixes`: same context rationalizes its own fixes; no independent evaluation.

`Unbounded cycles`: missing guards; resource exhaustion on infinite loop.

`Dismissals without reasons`: audit trail lost; patterns invisible; rules never improve.

`Full re-observation when nothing changed`: wasted compute; narrow to implicated checks.

`Termination on "looks good"`: elastic judgement; plateaus without converging.

`State only in context`: compaction erases it; no-progress check fails.
