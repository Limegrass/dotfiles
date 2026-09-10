# Avoid Opaque Vocabulary

Vocabulary a reader cannot recover -- incomprehensible truncations, ambiguous initialisms, and
non-descriptive coined names -- is replaced with a form whose meaning is recoverable.

## Tests

Three tests decide whether a token is a finding; `Do NOT flag` refines them.

`Comprehensible?`: a shortened form a general engineer reads at a glance and can confidently expand
(`spec`, `config`, `msg`, `id`) passes -- spelling it out adds no clarity. A truncation fails only
when ambiguous or heavily truncated, so the reader must guess which word it stands for (`hndlr`,
`rcv`), or when a bare single letter aliases a word (`r` for `rules`).

`Discoverable?`: a real, resolvable name of a tool, service, product, library, framework, system, or
team -- internal or external -- or a published standard, specification, or protocol, that a reader
can look up to a single, unambiguous referent passes, and needs no gloss in code or in prose. A
token resolving to many meanings fails: a widely-used initialism can map to a dozen or more
unrelated phrases (`PDP` is one), so fall back to Comprehensible?.

`Descriptive?`: a name coined in this change says what it holds or does. A name that parses as
English yet names no behavior (`doMagic`, `doStuff`) fails even though it is comprehensible.

## Why

- No brevity need: editors autocomplete, so a longer name costs nothing to type and pays back at
  every read. Code and docs are read far more often than written.
- Ambiguity, especially for automated reviewers and new readers: an incomprehensible short token maps
  to many meanings, and a bare `r` or `hndlr` forces a guess. A model guesses silently and can guess
  wrong; a comprehensible or spelled-out form removes the guess.
- Searchability: a spelled-out, unique token greps cleanly. An ambiguous truncation like `hndlr`
  collides with unrelated matches, so rename and impact analysis miss call sites.
- Onboarding and cross-team review: a token no outside reader can comprehend or look up is an
  invisible barrier.

## Diff scope

Flag only vocabulary this change introduces on added or changed lines: a new identifier declaration,
or newly-added prose, comment, or docstring text. Never ask the author to rename a pre-existing
symbol defined outside this diff that an added line merely references. Where every offending term is
pre-existing, there is no finding.

## Flag

- Incomprehensible truncations and single-letter aliases -- a shortened form a general reader cannot
  confidently expand: an ambiguous or heavily truncated form (`hndlr`, `rcv`, `evtProc`), or a bare
  single letter standing for a word (`r` for `rules`, `q` for `queue`).
- Ambiguous or context-specific initialisms that resolve to no single, well-known meaning -- `PDP`
  and the like, which map to many unrelated phrases, so a reader outside the team cannot know which
  one this codebase means.
- Non-descriptive names coined in this change -- an identifier describing nothing about what it holds
  or does: cutesy or metaphorical names (`doMagic`, `wizardry`, `doStuff`, a `franchise` variable
  that is not about franchises).

## Remedy

- Incomprehensible truncation or single-letter alias: rename to whole words -- `handler` not `hndlr`,
  `rules` not `r`.
- Ambiguous or context-specific initialism: spell it out on first use with the short form in
  parentheses -- `Full Phrase (PDP)` -- after which the short form is fine in that document.
- Coined name: rename to a term that describes function -- `retryScheduler`, not `doMagic`.

## Do NOT flag

### Comprehensible short forms

Acronyms, truncations, and numeronyms a general engineer reads at a glance without expanding. The
test is reader comprehension, not whether the word was shortened.

`Acronyms`: `ID`, `URL`, `URI`, `HTTP`, `HTTPS`, `API`, `JSON`, `XML`, `HTML`, `CSS`, `SQL`, `UUID`,
`AWS`, `IO`, `CPU`, `RAM`, `TCP`, `TLS`, `CLI`, `SDK`, `UI`, `UX`, `REST`, `RPC`, `CRUD`, `ASCII`,
`PDF`, `SLA`, `TPS`

`Truncations`: `spec`, `meta`, `config`, `info`, `repo`, `auth`, `sync`/`async`, `init`, `app`,
`env`, `regex`, `util`/`utils`, `admin`, `db`, `id`, `msg`, `req`/`resp`, `args`/`params`

`Numeronyms`: `a11y`, `i18n`, `l10n`, `o11y`, `k8s`

A word-qualified form -- `appConfig`, `userId` -- is likewise fine.

### Discoverable names

Real, resolvable names of tools, services, products, libraries, frameworks, systems, and teams --
internal or external -- plus published standards, specifications, and protocols, that resolve to a
single referent: `JaCoCo`, `Gradle`, cloud service names, `ARIA`, `WCAG`, `RFC 3339`, `ISO 8601`,
`UTF-8`, `POSIX`, `SemVer`, `JWT`, `OAuth`, `SAML`, and the like. The name is one lookup away, in
code and in prose.

### Names the author does not control

An external contract a rename would break: third-party or standard-library symbols, protocol or wire
field names (a protobuf field `evt_proc`), environment variables (`HNDLR_CFG`), external schema or
config keys, and generated code. Even where the token is itself a truncation, flag nothing -- the
author cannot rename it, and no gloss is required.

### Standard engineering vocabulary

`idempotent`, `throttle`, `backpressure`, `mutex`, `pagination`, `debounce`, `memoize`, `serialize`,
`race condition`, and the like.

### The product's ubiquitous domain language

The shared business vocabulary the system deliberately models -- `invoice`, `shipment`,
`entitlement`, `chargeback`, `ledger`, `fulfillment`, `tenant`, and their equivalents in whatever
domain the code serves. Domain-Driven Design requires code to speak this language; these are precise,
established domain nouns, so never suggest a plainer synonym.

### Terms the repository itself documents

Resolve an otherwise-ambiguous acronym against the repository's own reference docs -- `README`,
`AGENTS.md`, a glossary -- when present. One that expands the token to a single referent settles it.
An acronym documented nowhere is not blanket-exempt.

### Terms recoverable from the document's own context

A term expanded or defined anywhere in the same file or prose block (not only on first use), in a
glossary, terms, or definitions section, at an earlier or later occurrence, or in a linked design
document carrying the list. Recoverability, not placement, is the test.

### Acronyms built from a name visible in this change

A token whose letters are the initials of the package, repository, service, or pipeline the diff
belongs to, or of any directory or module in a changed file's path -- every changed path is in front
of the reviewer, not only the commented file's own. `IMS` alongside a changed
`inventory-management-service/` path is recoverable by expanding it against that name, and a package
or module name is a resolver the Discoverable? test accepts. An acronym matching no such name remains
a finding.

### Acronyms qualified by an adjacent discoverable proper noun

A product, service, framework, or system name beside an initialism, forming a phrase that resolves to
a single searchable referent -- `Kubernetes CRD`, `PostgreSQL WAL`, `TLS SNI`. The qualifier
disambiguates the initialism, even where the same initialism also appears bare in the file.

### Document-genre initialisms

Shorthand conventional to the kind of document being written and single-meaning within that genre.
Infer the genre from the file's name, title, or section structure.

`Design documents`: `HLD` (High Level Design), `LLD` (Low Level Design)

`Proposals and decision records`: `RFC` (Request for Comments), `PRD` (Product Requirements
Document), `ADR` (Architecture Decision Record)

`Early-stage planning`: `POC` (Proof of Concept), `MVP` (Minimum Viable Product)

This exempts only an initialism both conventional to that document type and single-meaning within it.
A team- or product-specific acronym that is ambiguous or coined here is not genre-standard.

### Conventional single-letter loop or math indices

`i`, `j`, `x` -- not abbreviations.
