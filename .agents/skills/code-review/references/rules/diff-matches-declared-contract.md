# Diff Matches Declared Contract

The review description declares the work and names the evidence; the diff performs the work and
carries the instrumentation the evidence needs.

## Why

The description is the contract a reviewer reads before the diff. It sets where to look, what was
checked, and what could break. Work the contract does not declare escapes that direction and gets
read as incidental. Work the contract declares and the diff omits sends the reviewer hunting for
code that is not there.

Named evidence carries the same weight. A metric, dashboard, or query named in the description that
nothing in the change emits is missing instrumentation, and it is cheaper to add while the code is
open than to explain at review -- the point of naming evidence during drafting.

## Scope

The review description under review, judged against the diff. The description accompanies the diff
at review time, so quoting it is diff-visible evidence.

Commit messages are out of scope. `conventional-commits-single-responsibility.md` owns
message-versus-diff match, so the same mismatch is not a finding twice.

Judge only what the description claims and what the diff shows. Section presence is a finding only
where the diff itself shows the need -- the format's sections are a menu, and dropping one the change
does not touch is correct.

## Flag

### Diff work no section declares

Added or changed lines performing a purpose no section of the description accounts for -- a second
subsystem touched, a behavior change under a description that reads as a refactor, a new dependency
or configuration surface nothing mentions.

Name the lines and the section that would have to declare them.

### Declared work absent from the diff

A claim the diff does not perform: motivation naming a problem no added line addresses, a change
described that the diff never makes, an item listed as done with no corresponding code.

### Named evidence the change does not instrument

Verification names a metric, dashboard panel, or log query, and no added line emits it. Trace the
call chain visible in the diff first -- a delegated method or shared emitter frequently already
produces it, and a second emission is the defect.

The finding is the missing emission, not the claim: the remedy adds the instrumentation the
description already decided it wants.

### Verification claiming a run that could not have happened

A result stated for a path the change does not reach, a command whose target the diff does not add,
or a query against instrumentation that lands in this same change and so had no data to return.

### Tests claimed with no test in the diff

Verification claims added or updated tests and the diff adds none. A green pre-existing suite is not
the claim -- the format already says a green suite cannot tell a new code path from the old.

### Verification silent on a redirected path

The diff moves an existing caller onto a new path and verification names no check that distinguishes
the two. Omission in verification reads as covered, which is why the format requires a reason for it
rather than a dropped line.

### Risk or rollback absent where the diff reaches shared state

The diff changes deployed configuration, a schema, persisted data, a public interface, or anything
whose effect outlives a binary rollback, and the description carries no risk or rollback content.
The `[if: ...]` condition on those sections holds, so their absence is a gap rather than a menu
choice.

## Remedy

- Undeclared diff work: move it to a later change, or add the section that declares it.
- Absent declared work: add the work, or drop the claim.
- Uninstrumented evidence: add the emission on the layer that owns the event, in the mechanism the
  changed file already uses.
- Unrunnable claim: state what was actually run, or mark the path not verified with its reason.
- Missing tests: add them, or drop the claim.
- Redirected path unverified: name the check that exercises the new path, or record it as not
  verified with a reason.
- Missing risk or rollback: add blast radius and mitigations, and the revert, flag flip, or redeploy
  steps plus the signal that calls for them.

## Do NOT flag

- A conditional section the change legitimately drops. `[if: ...]` gates it, and a change the
  condition does not describe drops it rather than filling it with "n/a".
- Motivation absent where the commit body already carries it. The format gates that section on
  exactly that.
- Absent measured numbers. The description supplies names and questions; the run supplies values.
- Incidental non-exclusive changes riding along -- formatting, a dependency bump, a doc typo. The
  commit rule exempts them, so the description need not declare them separately.
- Prose the reviewer could have inferred, or a section shorter than another change's. Density is not
  this rule's concern.
- Rationale that lives in the commit message and is embedded rather than paraphrased. That is the
  format working as intended, not a missing section.
- A named document or ticket link whose target the diff does not contain. External references are
  not instrumentation.

## Examples

Good:

- Verification names `OrderPlaced` count and the diff adds that emission in the service method.
- Description drops rollback for a test-only change.
- Description drops motivation because the commit body states the problem and the observable.
- Verification records "not verified: gamma canary -- no gamma stage for this package".

Bad:

- Verification names a p99 latency dashboard; the diff adds no timing metric (uninstrumented
  evidence).
- Description describes a retry policy; the diff also rewrites the timeout configuration with no
  section accounting for it (undeclared work).
- Verification claims "unit tests added"; the diff contains no test file or test method.
- Diff adds a table and a write path; description carries neither risk nor rollback content.
- Verification claims "suite green" as the only check for a caller newly routed through a new code
  path.
