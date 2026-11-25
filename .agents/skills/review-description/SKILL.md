---
name: review-description
description: >
  Fill the code review description -- what changed, how it was verified, what wants scrutiny --
  with evidence links a reviewer can open. Use when filling a review or pull request description,
  raising a review, or deciding what evidence reviewers need. Triggers on "fill the review
  description", "raise the review", "what goes in the description", "write the pull request
  description".
---

# Review Description

Draft before the work, one description for the set of commits under review.

Name the evidence while drafting. A metric graph, dashboard, or log query named in the draft that
does not exist yet is missing instrumentation, cheaper to add while the code is open than to explain
at review. Measured values land at review time -- the draft supplies names and questions, the run
supplies numbers.

A repository review template governs when present: its sections and field names win, and
sections it lacks come from the format below. A change with a spec assembles evidence from that spec
rather than restating it.

Durable rationale belongs in the commit message, which `commit-message` owns; the format embeds that
message rather than paraphrasing it. This description carries only what a reviewer needs before
merge, since review tools are unreachable from an editor and their links rot.

Sections are a menu -- drop one the change does not touch rather than filling it with "n/a", except
in verification, where an omission reads as covered and needs a reason.

## Reviewer Questions

Pre-merge reader. Holds the diff, can run commands and open links, loses the review at merge. Where
a tool generates a per-file walkthrough, the artifact owes only what that walkthrough cannot derive
from code.

`Why does this change exist`: the problem and the observable that shows it, not the mechanism.

`Why this mechanism and not another`: the mechanism chosen over the alternative that was considered,
and the precedent in the codebase it follows. A tool that generates a per-file walkthrough derives
what the code does; it cannot derive what was considered and rejected, so nothing else answers this.

`What is the blast radius`: who and what the change reaches when it is wrong.

`What could go wrong, and how would I detect it`: the failure mode paired with its signal. A failure
mode with no signal is undetectable, which is itself the finding.

`How do we get back to healthy`: revert, flag flip, or redeploy, and what calls for it.

`How was this verified, and can I verify it myself`: the check the run does not report, stated as
steps the reviewer can execute. A reviewer who can re-run the check does not need the assertion.

`Why not also fix the adjacent thing`: what the change deliberately left alone, each with the
evidence for leaving it. Unanswered, the reviewer raises it as a finding and the author answers it
in a comment thread instead of once, up front.

`Is anything blocking`: merge order, an unmerged dependency, a check that failed for a known reason.

`What must I do at deploy time`: steps a human runs in order, each with the state that confirms it
worked. Anything the pipeline runs on its own is not this question -- only work that stops without a
person.

`Where is the design that motivated this`: the ticket, spec, or document, linked rather than
summarized.

Questions gate sections. They are not fields to fill: a change with nothing adjacent left alone has
no out-of-scope content, and inventing some to look complete is the defect these questions exist to
prevent. An artifact that cannot answer a question its reader will ask is either missing a section
or describing work that is not ready. Distinguish the two before adding prose.

An `Answers:` line marks a section of the produced description and names a question the set above
defines. Guidance sections about producing the description do not carry `Answers:` lines.

## Format

Sections the commit message is forbidden to carry, plus reviewer-only material. `commit-message`
excludes mechanics, rollback procedures, follow-ups, and migrations. It also excludes
pipeline-reported facts, but those stay out of the description too -- the run computes them per
revision, so neither artifact carries a snapshot that becomes stale.

The description owns from that excluded set:
- rollback procedures
- follow-ups
- migrations
- approach-level narrative when commit body does not carry it

```markdown
# {{commit-title}}

{{commit-message-in-full}}

---

## Motivation [if: not in commit body]

Answers: `Why does this change exist`, `Where is the design that motivated this`

- problem, and the observable that shows it
- link to the motivating ticket, spec, or design

## Approach [if: approach-level narrative not in commit body]

Answers: `Why this mechanism and not another`

Approach-level narrative the commit body omitted: which mechanism was chosen, which in-file or
in-repo precedent it matches. A walkthrough tool cannot derive this from code -- code shows what was
done, not what was considered and rejected.

- mechanism chosen, and why
- precedent it follows (file, function, pattern)

## Out of scope, with reasons [if: the change deliberately left adjacent work alone]

Answers: `Why not also fix the adjacent thing`

What the change deliberately left alone, each with evidence for leaving it. Deliberate omissions
belong here, not in `## Approach`.

- what was left alone -- evidence for leaving it

Follow-ups belong here too, since `commit-message` forbids them and reviewers otherwise raise them
as findings.

## Migrations [if: the change requires deployment-time steps]

Answers: `What must I do at deploy time`

Steps the deployer runs in order, each with the state to verify afterwards. The gate is a manual
step -- anything the pipeline runs automatically stays out, anything requiring human action belongs
here.

1. Step -- verification command or observable
2. Next step -- verification

## How to test [if: a reviewer can run a check themselves]

Answers: `How was this verified, and can I verify it myself`

- command or steps the reviewer can execute
- expected observable, and what it means

## Verification [if: a check the run does not report was performed]

Answers: `How was this verified, and can I verify it myself`

Evidence that this is the correct change and that it works, limited to what the run does not report
on its own. Confirm a redirected code path directly -- a green suite cannot tell the new path from
the old.

- claim -- command or query run, result
- not verified: path, stage, or manual step -- reason it was skipped

## Verification after deploy [if: change reaches a deployed stage]

Answers: `How was this verified, and can I verify it myself` (post-merge half)

Separate from pre-merge testing. Post-deploy items read as numbered instructions, each naming its
observable, not as claims.

1. Observable to check -- how to check it
2. What signal says it is healthy

## Risk and Rollback [if: change reaches users or shared state]

Answers: `What is the blast radius`, `What could go wrong, and how would I detect it`, `How do we
get back to healthy`

- blast radius
  - mitigations
- rollback: revert, flag flip, or redeploy steps
- signal that says rollback is needed

## Blockers [if: anything blocks merge]

Answers: `Is anything blocking`

- merge order dependency
- unmerged dependency
- failing analyzer with reason

## References [if: supporting documents exist]

Answers: `Where is the design that motivated this`

Do not duplicate links if already used elsewhere.

- [title][link]

[link]: https://example.com
```

The placeholder `{{commit-message-in-full}}` carries the complete commit message including the
trailer block -- issue reference, review link, `BREAKING-CHANGE:`, and any other trailers --
verbatim. `commit-message` defines `Body` and `Trailers` as separate sections, so a placeholder
named "body" would exclude trailers by that skill's own vocabulary. Reproducing the trailers removes
a layer of indirection: the reviewer has the ticket and the motivating document in front of them
instead of following a hop through the commit message.

## Density

Bullets by default. One claim per bullet, one or two lines, front-loaded with the thing named --
metric, file, command, account, decision. A reviewer scans the description to find where to look,
and a scan reads a list faster than it reads a paragraph.

Prose only where a sentence carries what a bullet cannot: a causal chain, or a constraint that
falls apart when split. Two sentences per section is the ceiling. Past that, the content is either
rationale belonging in the commit message or a document belonging in references.

Nest one level to attach detail to a claim -- the evidence link under the claim it supports, the
mitigation under its blast radius. Wanting a second level means the parent bullet is a section.

## Machine-Reported Facts

Nothing the pipeline or the diff already reports. What the build computes per revision stays out
of the description, since the run states it correctly and a copy becomes wrong on the next push.
The `omit-pipeline-reported-facts` rule enumerates the bar and judges it; the principle is that
the pipeline recomputes status on every revision, so a sentence asserting it is redundant when
written and wrong after an amend.

What survives is the check a reviewer cannot watch run -- a manual step, a query against a stage, a
suite the build skips -- plus any expected check that did not run, with its reason.

## Template-Mandated Machine Facts

A repository review template governs field names and its checklists use Y/N/NA answers. Where such a
field asks about a machine-reported fact, give the Y/N/NA answer the template demands, then name the
reporter -- nothing else.

Example:

```
Coverage threshold met? Y (coverage reporter)
```

The answer is `Y`, `N`, or `NA`. The parenthetical names the reporter. Do not pad with restated
facts about how reporters work -- "the coverage reporter reports it per revision" wastes tokens on
how-reporters-work instead of naming the reporter.

Evidence: a coverage checklist item answered with "new code 100%, updated code >=90%" while the
coverage reporter published "currently 100.0%" in the same review. The prohibition is on copying the
measured value, not on answering the template's question. Naming the reporter makes the answer
correct indefinitely; copying the value makes it wrong on the next push.

## Comment Routing

A comment helps the reviewer understand what the change introduces at the line it sits on -- the
decision behind it, a question about it, where to look first. Sitting there is the point: the same
sentence in the description makes the reviewer hunt for the code it refers to.

A reviewer question with a line to attach to is answered at that line; only a question spanning the
whole change needs the top-level description. A concern attachable to a `file:line` becomes a draft
inline comment on that range. The test is existence of a line to attach to, not whether one could be
hunted for.

Content that routes to comments:
- Decision-level uncertainty on a specific line
- Where-to-look guidance for a file or function
- "Watch this" notes on a tricky block
- Alternative considered at a decision site

Content that stays in the description:
- Approach or sequencing spanning the change
- Blast radius affecting multiple files
- Out-of-scope reasoning not localized to one site

The review tool identifies comment locations by package, file path, and line range; the exact string
format is the tool's. Comments draft by default. A publish action releases every draft on the
revision, not just the one being added -- so leave drafts for the user; never publish
programmatically. The user publishes after reviewing the set.

Output marking: when producing a comment for routing, mark it explicitly as a pending draft. A
reader of the output otherwise assumes the comment already exists in the review tool.

## Draft Locations

A draft written after the review exists can be keyed on the review's identifier. A draft written
before the review exists has no such key, so write it alongside the work and move it after the
review is raised.

## Walkthrough Tool Exclusion

Tools that generate ordered per-file walkthroughs from code produce per-file commentary explaining
what changed and why, with line-by-line narrative. Exclude what such tools produce: per-file change
narrative, code mechanics, line-by-line explanation.

Walkthrough tools derive from code. They cannot derive approach-level narrative -- which mechanism
was chosen, which in-file precedent it matches, and what the change deliberately does NOT do. That
narrative belongs in the description's `## Approach` section when the commit body does not carry it.

Distinction:
- Tool-derivable (exclude): "lines 45-60 add the null check", "the function now returns early"
- Not tool-derivable (include): "guards at the client entry matching getRecommendedNextStep",
  "does not restore eligibility filtering -- that requires the host page to pass the prop"

When no walkthrough is generated (reviewer did not run the tool, or the tool failed), the reviewer
lacks the per-file explanation. The description does not expand to fill that gap -- the walkthrough
content is derivable from code, so its absence is the tool's problem, not the description's.

## Judge

Before applying the description, delegate a read-only judge scoring it against the reviewer
question set and the bars stated above:

- Machine-reported fact leakage: coverage percentages, build verdicts, test counts copied rather
  than reporter named
- Trailer presence: issue reference, review link, `BREAKING-CHANGE:`, and other trailers from the
  commit appear verbatim
- Section-question alignment: each section answers a named reviewer question; no section exists
  without one
- Comment routing: concerns on a known `file:line` belong at that line, not in the description

The judge runs once on the description, which already covers the set of commits under review.
Per-description judging is the natural unit because the description is one artifact containing
embedded commit messages.

Loop mechanics -- actor/judge separation, no-progress guards, state ledger -- defer to
`agentic-loop-design`. Terminate on actionable count reaching zero. Iteration cap (10 typical) is a
guard that forces exit with findings outstanding, not a terminal condition -- a loop hitting it
exits with work undone and must report the remaining set.
