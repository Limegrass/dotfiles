# Omit Pipeline-Reported Facts

Whatever the build reports on its own stays out of the history and the review record: the pipeline recomputes it every revision.

## Why

The pipeline recomputes status on every revision and reports it beside the change: build result,
test outcome, coverage, lint verdict, files and lines touched. A sentence asserting any of it is
already redundant when written, and a later amend, rebase, or push leaves it asserting something no
longer true -- history keeps the sentence, not the run it described.

The claim is also unverifiable in the place it lands. A reviewer confirms "tests pass" from the run
regardless of what the message says, so the sentence only spends the attention the motivation
needed. `git log` output narrows the reader's window; a line of status pushes the reasoning out of
it.

## Scope

Commit messages in the change, plus prose the diff adds to tracked documents (readme, changelog,
design doc, plan) that reports a build or test verdict, plus the review tool's description field
(justified under Review Discipline's diff-visible-evidence clause).

The `review-description` skill still owns the description's format and density bar. This rule judges
the pipeline-facts bar wherever it is stated -- message, tracked prose, or description -- so one bar
has one judge.

## Flag

### Build or test verdict

Any assertion of what the run decides: "build passes", "all unit tests green", "pipeline clean",
"no regressions", "verified by CI", "tests were run".

### Counts read off the diff or the run

"23 tests added", "+412/-88", "3 files changed", "coverage now 87%", "reduced by 40 lines".

### Checker verdict restated as content

"lint clean", "formatter satisfied", "type checker happy". Describing what the change does to a
checker is content; asserting the checker's answer is not.

### Template-mandated field answered with machine-reported fact

A repository review template checklist item whose subject is a machine-reported fact, answered
by copying the value rather than naming the reporter. Example: a coverage item answered with
"new code 100%, updated code >=90%" while the run shows the same numbers. Remedy: name the reporter
-- "covered by the build", "the coverage reporter shows it" -- and drop the value.

## Remedy

- Delete the sentence. Nothing replaces it -- the run already carries it.
- Where the assertion is the whole body, the motivation was never written: state the problem and the
  observable that shows it instead.
- Where the claim covers a check the build does not run -- a manual step, a query against a stage, a
  skipped suite -- it belongs in the review description's verification section, per
  `review-description`.

## Do NOT flag

- A message describing a change to the checks themselves: `ci: raise coverage gate to 80%`,
  `test: cover the empty-input path`. That states what the diff does.
- Measured data motivating a decision -- benchmark latency, a load-test result, a metric from a
  stage. The pipeline does not report it, and `commit-message` asks decisions be motivated with
  data.
- Naming a test that reproduces the defect, where the name identifies the observable rather than
  claiming a pass.
- A test or build claim in prose the diff did not touch.
- Any file the review tool owns rather than the repository.
- Naming the reporter without a value -- "the coverage reporter shows it", "the build fails on
  regression" -- is the compliant answer and is never a finding.

## Examples

Good:

- `fix(auth): reject session cookie rotated mid-request` with a body naming the observable, no
  status line.
- `ci: fail the build on coverage below 80%` -- the gate is the change.
- `perf(index): batch writes` with a body citing 340ms -> 90ms at p99 from a named benchmark.

Bad:

- `fix(auth): reject stale session cookie` with body `All unit tests pass and the build is green.`
- Body line `Changed 3 files, 412 insertions, 88 deletions.`
- Body line `Coverage rose to 87%.` where no coverage change is the point.
- Changelog entry added by the diff reading `Validated by pipeline run 4821.`
