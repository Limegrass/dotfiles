# Conventional Commits and Single Responsibility

Each commit follows Conventional Commits, carries at most one behavior-changing type, and its
description matches its diff.

## Why

Rollback, `git bisect`, and backport act per commit. A commit combining two behavior-changing types
forces an all-or-nothing `git revert` (the fix cannot be undone without also reverting the feature),
prevents `git bisect` from attributing a regression to a single change, and blocks cherry-picking one
change onto a release branch. Separation also keeps each change and its review small and
single-purpose, which reviewers read and reason about faster.

Trailer validity is load-bearing for the same reason: `git interpret-trailers --parse` returns
nothing for a malformed block, silently dropping every trailer in it. A bad label costs the author
the links they wrote, not merely tidiness.

## Scope

Commit messages in the change. Judge the messages only -- a review tool's own description field is
not a commit message, so a free-form label written there is not a finding.

## Message format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

The body explains what changed and why, not how -- the diff shows how.

### Common types

These are the types most projects use, not a closed set. A type outside the table is a finding only
where it obscures what the commit does; a project that uses its own type consistently is fine.

| Type | Purpose |
| :--- | :--- |
| `feat` | A new feature visible to the end user |
| `fix` | A bug fix visible to the end user |
| `docs` | Documentation-only changes |
| `style` | Formatting, whitespace, or cosmetic changes (no logic change) |
| `refactor` | Code restructuring with no feature or bug-fix change |
| `perf` | Performance improvement with no functional change |
| `test` | Adding or correcting tests only |
| `chore` | Build process, tooling, or dependency updates |
| `ci` | CI/CD configuration changes |
| `build` | Changes that affect the build system or external dependencies |
| `revert` | Reverts a previous commit |

An optional noun in parentheses names the section of the codebase affected: `feat(auth):`,
`fix(parser):`.

## Flag

### Combined behavior-changing types

`feat`, `fix`, `refactor`, and `revert` are mutually exclusive within one commit. Flag a commit only
when its diff performs two or more of them. Determine each commit's kinds from the diff, not the
message -- a `feat:`-typed commit whose diff also fixes an unrelated bug combines `feat` and `fix`.

All other types (`docs`, `style`, `perf`, `test`, `chore`, `ci`, `build`) combine freely, with each
other and alongside one mutually-exclusive type. A type outside the table is non-exclusive unless its
diff performs one of the four exclusive kinds, which the diff decides regardless of the label.

When flagging, also list the non-exclusive changes present in the same commit and name which split
commit each can travel with, so the split guidance is complete. Listing them is not flagging them --
they are not violations.

### Description that does not match the diff

- Misleading: claims something the diff does not do, or omits a significant part of the diff.
- Too vague to convey intent: `fix: various fixes and cleanup`, `chore: updates`.

Tests that verify a feature or fix belong in the same commit as that change.

### Breaking change not marked

A breaking change appends `!` after the type or scope, carries a breaking-change footer, or both.
Write that footer as `BREAKING-CHANGE:`. Conventional Commits defines the hyphenated form as
synonymous with `BREAKING CHANGE:`, and only the hyphenated form is a valid git trailer token -- the
spaced form voids the trailer block, barring the reprieve below.

```
feat(api)!: remove deprecated /v1 endpoints

BREAKING-CHANGE: The /v1 API endpoints have been removed. Migrate to /v2.
```

### Line that voids the trailer block

Footers live in the trailer block -- the message's final paragraph, every line of it `token: value`
with the token matching `[A-Za-z0-9-]+`. Git reads the block only while that holds for every line.
One line that breaks it (`See also: <url>`, a bracketed tag) makes `git interpret-trailers --parse`
return nothing, dropping every trailer in the block whatever the offending line's position. The only
reprieve is a block that also carries a Git-generated trailer (`Signed-off-by:`, a cherry-pick line)
or one configured via `trailer.<token>` and is at least one-quarter trailers, where just the invalid
line drops.

Flag a trailer-block line that is not `token: value` with a `[A-Za-z0-9-]+` token: a token carrying
whitespace (`See also: <url>`), or a line with no token shape at all (a bracketed tag, bare prose).

### Tooling-fixed token spelled differently

A project fixes a small set of trailer tokens because tooling writes or reads them -- typically one
for the issue or ticket reference and one for the review link, the latter at most once. Flag a
variant spelling of either, and a second review-link line: the tooling writes that line itself, so a
variant duplicates it or leaves a stale one. A link to a review other than the one this change is
under is an ordinary reference and must not use the review-link token.

Every other reference -- external docs, a wiki page, a specification -- is free-form: any valid token
records it. `ref:` is a reasonable default for an author with none in mind, never a requirement.

## Remedy

- Combined types: split so each commit performs at most one of `feat`, `fix`, `refactor`, `revert`.
- Description: rewrite to state what the diff does, at the specificity the diff shows.
- Breaking change: add `!` and a `BREAKING-CHANGE:` footer.
- Invalid trailer line: hyphenate the token (`See-also: <url>`), rename it to `ref: <url>`, or move
  the line into the body, above the blank line that precedes the trailer block.
- `BREAKING CHANGE:` spaced: use `BREAKING-CHANGE:`, which Conventional Commits defines as
  synonymous.
- Variant tooling token: use the project's canonical spelling, once.

## Do NOT flag

- A non-exclusive change riding along with one exclusive change -- a `feat` diff that also reformats,
  bumps a dependency, adds tests, or fixes a doc typo.
- A commit spanning multiple files, subsystems, or scopes while performing at most one exclusive
  kind.
- Multiple changes of the same exclusive type, such as two bug fixes.
- A reference under a valid token other than `ref:`. The block parses either way and the intent is
  recorded, so the token choice is the author's.
- A type absent from the table above. The list illustrates the common set; a type the project uses
  consistently and that names a coherent kind of change records intent as well as a listed one.
- A URL cited inline in body prose. A labelled footer is required only where the author presents the
  reference as a line of its own.

Corollary: never use this rule to demand edits to pre-existing code. Where another rule's finding
could be satisfied only by editing untouched lines, that edit belongs to a later change -- leave the
pre-existing code alone rather than pushing the author into a change this rule would then flag.

## Examples

Good:

- `feat(cart): add quantity selector to cart items`
- `fix(auth): prevent session fixation on login`
- `refactor(db): extract connection pooling into shared module`
- `feat(cart): add quantity selector` -- diff may also add tests and bump a dependency (one exclusive
  type plus non-exclusive changes).

Bad:

- `feat(cart): add quantity selector and fix auth bug` (`feat` + `fix`).
- `refactor(db): extract connection pool and add retry feature` (`refactor` + `feat`).
- `fix: various fixes and cleanup` (too vague to match the diff).
