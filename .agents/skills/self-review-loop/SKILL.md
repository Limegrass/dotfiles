---
name: self-review-loop
description: >
  Loop a delegated reviewer over your own change until no actionable finding remains --
  fix, re-observe, repeat, with a build or test gate beside the judgement. Use when
  asked to self-review, "review my work until clean", "loop the reviewer", "iterate on
  review findings", "did I stay in scope", or as a gate before raising the review.
  Distinct from code-review, which is one pass that reports and does not fix, and from
  a loop that resolves findings from an automated code analyzer, which judges against
  machine rules rather than a local rule set.
---

# Self-Review Loop

Isolate the change, resolve the contract it declared, then loop: observe (delegated
`code-review` pass plus a mechanical gate) -> triage -> fix -> re-observe, until no
actionable finding remains and the gate is green.

`Contract`: what the change declared before it was written -- the commit message per commit
(`commit-message`) plus the review description for the set (`review-description`). The contract
bounds scope, so it is a review input, not documentation.
`Review surface`: what the review covers -- staged work, working tree, or commit range, as
`code-review` establishes it.
`Mechanical gate`: build and test command for the package. Binary, unlike judgement.
`Actionable`: findings raised minus findings dismissed with a recorded reason.

## Loop Mechanics

`agentic-loop-design` governs role separation, observable termination, fingerprints, dismissal
authority, guards, and ledger persistence. Read it rather than re-deriving any of them here.

## Preconditions

Verify before starting; stop with guidance if any fail.

- Edits auto-accept, else every fix stalls on a confirmation prompt.
- Tree holds the change under review and nothing else. Park unrelated edits before starting and
  surface them on every exit path. A file mixing the change with unrelated edits is committed
  whole rather than split hunk by hunk -- a partially staged file can be syntactically broken
  and would have the loop judge a state that never existed on disk.
- Implementation complete and its own tests green. This loop judges a finished change; running it
  mid-implementation reviews scaffolding.
- Contract resolved -- see below.
- Mechanical gate command known. Discover from the project's build context and ask when it cannot
  be discovered.

## Contract Resolution

A draft written after the review exists can be keyed on the review identifier and is worth
checking first. A draft written before the review exists cannot be keyed that way -- exactly when
a contract is supposed to be drafted. Before the review exists, resolve from sources in order and
stop at the first that answers:

1. Commit messages in the range: `git log <range> --format=%B`. Always read these -- they are the
   per-commit half of the contract and `code-review` passes them to every rule regardless.
2. A local review-description draft or the spec section that states the intended change.
3. The remote review description, when a commit trailer names the review or the user names one.
   Fetch it; do not reconstruct it.

Local draft and remote description disagreeing is reported, never silently reconciled -- the
divergence is itself information about which one the change followed. Ambiguity about which source
governs asks the user; reviewing against the wrong contract invalidates every scope finding.

## Cycle

Maintain the ledger across cycles (see State). Each cycle:

1. Observe. Delegate the `code-review` pass over the review surface, with
   `diff-matches-declared-contract` always among the selected rules and the resolved contract handed
   to it alongside the diff. In parallel, run the mechanical gate.
2. Triage. Actionable = findings returned minus fingerprints already dismissed in the ledger. Gate
   failures are actionable unconditionally and are never dismissable.
3. Reconcile the contract, where the diff outgrew it -- see below.
4. Fix. Main agent by default; delegate per file group past the threshold below.
5. Record. Write cycle number, actionable fingerprints, dismissals with reasons, contract
   amendments, and gate status to the ledger.
6. Increment and return to 1, re-observing narrowly: the rules that fired plus those the fix diff
   newly implicates. The terminating cycle re-runs the full selected set.

## State

Ledger in an untracked file -- `.git/SELF_REVIEW_LOOP.json`, under `.git/` because that directory is
untracked by construction, so the ledger cannot land in the diff. The no-progress guard compares
fingerprint sets across cycles, so it cannot live in context.

Fingerprint a finding as `<rule file>:<file>:<line>`, which is exactly what `code-review`'s output
shape already anchors. Fixes shift line numbers, so treat a fingerprint whose rule and file match
but whose line moved as the same finding.

## Fixer Selection

Main agent by default: it holds the contract and the aggregated findings, so it sees interactions a
per-file delegate cannot.

Delegate one sub-agent per file group once the actionable set exceeds six findings across three or
more files. Below that, dispatch and context-transfer cost more than the fixes. Group strictly by
file -- two delegates editing one file race, and the loser's edit vanishes.

Sub-agents return fixed, dismissed-with-reason, or blocked. Blocked findings escalate to the main
context; they are not silently dropped.

## Contract Reconciliation

The diff outgrowing the contract is a finding, not a bookkeeping detail. Two remedies:

- Move the excess out -- a later commit or a parked change, leaving the diff matching what it
  declared.
- Amend the contract, where the extra work genuinely belongs to this change.

Never widen the contract silently to make a finding disappear: that converts a scope violation into
an unreviewed scope expansion. Record every amendment in the ledger and list it in the report.

## Termination

Primary: zero actionable findings, green mechanical gate, contract reconciled, confirmed by one full
pass over the selected rule set rather than a narrowed one.

Guards per `agentic-loop-design`. Max cycles defaults to 4: a cycle here spawns one sub-agent per
selected rule, so cost scales with the rule set, and judgement converges faster than machine
findings. A set still contested at cycle 4 wants a human, not a fifth cycle.

## Report

```
## Self-Review

Cycles: <n> (<termination reason: clean | no-progress | max-cycles>)
Gate: <pass | fail -- what failed>

### Fixed
- <fingerprint> -- <the edit made>

### Dismissed
- <fingerprint> -- <reason, quoting the clause that exempts it>

### Contract amendments
- <section> -- <what changed and why>

### Unresolved [if: guard exit]
- <fingerprint> -- <why it did not converge>
```

## Traps

- A dismissal quotes a clause: the rule file's `Do NOT flag`, or `Review Discipline` in
  `code-review`. Without one it is preference overruling a rule, and the loop terminates vacuously
  while the report reads clean.
- Fixes touch only lines the change already touched. Editing untouched code to satisfy a finding
  grows the change past its purpose, which the commit rule then flags -- and the next cycle raises
  it.
- Running before isolation reviews unrelated edits, so findings arrive for code the change never
  claimed and every scope judgement is wrong.
- Findings arrive already validated against their rule by the sub-agent that held the evidence.
  Re-judging them in this context reintroduces the rule text the delegation exists to keep out.
- Re-observing narrowly assumes the fix broke nothing elsewhere. The full pass on the terminating
  cycle is what catches that assumption failing; skipping it forfeits the guarantee.

## Position

```
draft contract -> implement -> tests green -> self-review-loop -> automated analyzer -> review
```

This loop runs before any automated analyzer pass. A change that fails its own contract wastes
that pass, and an analyzer result keyed on the diff is invalidated by every later fix.
