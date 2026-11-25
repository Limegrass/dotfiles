# Narrow Stringly-Typed Data

A `String` / `string` / `str` declaration wider than the data it carries -- a closed value set or
serialized data hidden in a string -- gets the type the data actually has.

## Why

A string typed over an enum or a structured payload puts the constraint outside the type system:
neither compiler nor request validator can reject an invalid variant or a malformed payload, so every
consumer re-validates by hand and an illegal state stays representable.

## Diff scope and intent

A bare string with no enumerated values and no serialized-data signal is not a finding. Narrowing is
required only where the diff itself shows the data is narrower than the declared type.

Flag only a declaration this change introduces or modifies -- a field, parameter, or return whose
declaration line is added or changed. A pre-existing declaration on an unchanged context line stays
untouched even where the change adds the very evidence that reveals the narrower type: a new switch, a
new equality comparison, a new doc comment listing values. Retyping an untouched declaration forces
edits the change did not set out to make. Where every candidate declaration sits on an unchanged line,
there is no finding.

The declaration must also be part of what the change sets out to do. Establish intent from the commit
message together with the diff's dominant added content -- a new model, DTO, entity, API shape, or a
type being deliberately reshaped. A declaration the change only touches incidentally is not a finding:
threading an existing parameter through a new call site, adding a caller, a rename, a reformat, a
moved-but-unchanged declaration.

## Flag

### Closed value set typed as string

An added or changed string-typed field, parameter, or return whose adjacent, diff-visible evidence
enumerates a fixed set of values:

- a doc comment listing values -- `/// e.g. "PENDING", "APPROVED".`, `one of ...`, `valid values:`,
  `must be one of`;
- the changed code compares the value against a fixed set of string literals -- a switch or if-chain,
  `equals("DRAFT")`, a `match`, a set-membership check.

Suggest the language's closed enum so compiler and request validator enforce the domain.

| Language | Construct |
| :--- | :--- |
| Interface definition language | `enum` shape or enum schema |
| Java, Kotlin | `enum` |
| Rust | `enum` |
| TypeScript | string-literal union or `enum` |
| Python | `enum.Enum` |
| Go | typed `const` / `iota` set |

Read Wire and persisted surfaces before suggesting this on an interface-definition field, a wire or
DTO field, or a persisted column.

### Serialized data hidden in a string

A string holding serialized or composite data -- JSON, XML, CSV, delimited, `key=value` -- that is
persisted (entity, attribute, column) or crosses an API boundary (request or response field).
Evidence: the field name or doc says `json`, `serialized`, `payload`, or `blob`; or the diff serializes
an object to a string to store or transmit it.

Suggest a structured type -- a nested structure in the interface definition, a typed object, record,
or struct in the file's language -- so the schema is explicit, validated, and evolvable rather than an
opaque blob inside a string.

## Wire and persisted surfaces

Applies in any language. On interface-definition files, generated-model or DTO surfaces, and any string
that is the persisted or on-the-wire representation, an enum is fine for the typed surface, but the wire
keeps accepting arbitrary string values. A closed enum that rejects unknown values breaks forward
compatibility the moment a producer emits a value added after this deploy -- a failure mode that has
taken services down.

Recommend an open or string-backed enum tolerating an unknown variant: an interface-definition enum with
an unknown fallback, a `#[non_exhaustive]` Rust enum, a TypeScript `string` widened from the literal
union at the boundary, or keeping the string on the wire with a typed accessor. Never recommend a
representation that drops or rejects unknown wire values, and state this trade-off in the finding.

## Do NOT flag

- Genuinely free-form or opaque strings: identifiers (`orderId`, `sessionId`, `correlationId`), human
  names, descriptions, URLs, tokens, free text. No closed value set exists.
- A field already typed as an enum or a structured type -- it already expresses its shape.
- A string with no enumerated-value or serialized-data evidence in the diff.
- Recommending a closed enum for a wire or persisted string that would reject unknown values -- that
  suggestion is itself the defect.
- A pre-existing declaration the change did not introduce, or one the change only touches incidentally.
