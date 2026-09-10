# High-Signal Code Documentation

Comments, docstrings, and inline documentation earn their place by documenting the non-obvious.

## Why

Excess documentation buries the code it describes and makes the change harder to read. Attention
spent on restated knowledge, narrative, or point-in-time names is attention not spent on the logic.

## Limits

- Documentation volume and quality only. Never flag the code itself under this rule.
- Documentation occupying its own line or lines only. A trailing comment sharing a line with the code
  it annotates (`i += 1  # increment i`) adds no vertical space and buries nothing, whatever it says.
- Documentation the author does not control -- comments and docstrings in generated code (generated
  clients or models) or vendored dependencies -- even on added lines, because no action is available
  there.

## Flag

### Generally-accepted or industry-standard knowledge

Examples: "a malformed request returns HTTP 400", "null input throws", "this loop is O(n)", "JSON must
be valid to parse".

Restating common knowledge spends reader attention and signals nothing specific to this code.
Remedy: delete it.

### Restating what the code already says

Example: `# increment i` above `i += 1` -- a standalone comment or docstring line re-stating the logic
it sits above with no added meaning.

Remedy: delete, or replace with the WHY where a non-obvious reason exists.

A docstring or header comment stating a class or function's overall purpose, and any parameter or
return description, are not restating -- see Keep.

### Volume that buries the code

Examples: a 30-line comment block in front of a 10-line function; the same multi-paragraph rationale
repeated at every call site.

Remedy: keep the one or two load-bearing facts; move long-form rationale to a linked design doc or
ticket.

### References to specific people

Examples: `CONFIRM-WITH-<NAME>`, "per <NAME>'s review", "ask the on-call", a named engineer.

Names are point-in-time; ownership and open questions belong in the code review, ticket, or design
doc, not in source that outlives the conversation.

Remedy: remove the name. Where an open question remains, track it in a ticket and link that.

### Development history or narrative

Examples: "an earlier version dropped this", "we then decided to...", "fixed in this change",
"previously this used X", "VERIFIED on 2026-06-27".

History lives in git, not prose. Comments describe the system as it is now, not how it came to be or
who changed it when.

Remedy: rewrite as a present-tense statement of current behavior; delete the history.

Past-tense narrative only. Forward-looking references are permitted -- see Keep.

## Keep

Documentation stays, and is never a finding, in these cases:

- Unexpected or non-obvious behavior: surprising constraints, gotchas, why a workaround exists.
- Business or domain reasoning: the WHY behind a choice not evident from the code.
- Load-bearing invariants: a fact whose violation causes a bug ("this field must be set before the
  call or the server rejects the request").
- Links to authoritative sources (an owning service's model or code, a specification) instead of
  reproducing them at length inline.
- References to future state: forward-looking notes about planned work or intended direction --
  TODO/FIXME pointers, "will be replaced when X ships", "future: support Y". They give a reader
  actionable context about where the code is going and are not past narrative.
- Whole-unit summary of a class, type, module, or function -- a docstring or header comment stating
  what the unit IS or DOES, its purpose or responsibility as a whole -- even where the name already
  hints at it. It gives the unit one authoritative description and orients the reader; never flag such
  a summary merely because a reader could infer it from the name or signature. The boundary is
  granularity: this covers the whole-unit summary only. Documentation walking the body
  statement-by-statement -- a comment on nearly every line, or a docstring re-narrating each
  implementation step -- remains a finding under volume that buries the code.
- Parameter or return description: a `@param` / `@arg` / `@return` entry, or its language equivalent,
  carrying a description, however brief or obvious, even where the description only echoes the
  parameter's name or type (`@param userId  the user id`). Never flag a parameter or return description.
