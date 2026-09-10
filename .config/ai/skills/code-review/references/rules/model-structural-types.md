# Model Structural Types

A type wider than the data it carries -- mutual exclusivity or optionality left unexpressed -- gets the
shape that makes an illegal state unrepresentable.

## Why

Sum types and explicit optionality move the constraint from prose into the type. Sibling fields where
only one is ever populated force every consumer to defend against combinations the domain forbids, and
a nullable field documented as always present spreads dead null-handling downstream while an unmarked
absent field crashes the first caller that trusts it.

## Diff scope and intent

A type is flaggable only where the diff itself documents a mutual-exclusion or optionality invariant
the declared type does not enforce.

Three gates limit what is flaggable.

Added or changed declaration: flag only a structure, class, field, parameter, or return whose
declaration line this change adds or modifies. A pre-existing declaration on an unchanged context line
stays untouched even where the change adds the very evidence that reveals the invariant -- a new doc
comment, a new conditional, a new factory method. Reshaping an untouched type forces edits the change
did not set out to make.

Structure-level findings need the structure itself: for the mutually-exclusive-fields finding, this
change must introduce or deliberately reshape the structure. A pre-existing structure that merely gains
a field is not in scope, because replacing it with a sum type rewrites call sites the change never
touched.

Intent: establish purpose from the commit message together with the diff's dominant added content -- a
new model, DTO, entity, API shape, or a type being deliberately reshaped. A declaration the change only
touches incidentally is not a finding: adding a caller, threading a value through a new call site, a
rename, a reformat, a moved-but-unchanged declaration.

## Flag

### Mutually-exclusive fields

A structure or class introduced or reshaped by this change where only one of several fields is
populated at a time, or a boolean or string discriminator paired with fields that are only conditionally
present. Evidence: doc text such as `Exactly one variant is populated`,
`Non-empty only when <flag> is true`, `Only when ...`, or a flag whose value decides which sibling
fields are set -- `partial: Boolean` beside a `failedItems` list documented "non-empty only when
partial".

Suggest the language's sum type so impossible field combinations cannot be constructed.

| Language | Construct |
| :--- | :--- |
| Interface definition language | `union` shape or `oneOf` |
| Java | `sealed interface` |
| Kotlin | `sealed class` or `sealed interface` |
| Rust | `enum` with data-carrying variants |
| TypeScript | discriminated union |
| Python | tagged dataclasses or `typing.Union` |
| Go | small sealed-interface set |

### Optionality not expressed

An added or changed field whose doc or code states it is conditionally present while the type does not
say so -- or the reverse:

- documented optional or conditional (`optional`, `may be absent`, `null when ...`,
  `Non-empty only when ...`) but modeled non-optional: a required interface-definition member, a
  non-nullable type, a Go value rather than a pointer, a TypeScript property without `?` or
  `| undefined`;
- documented or used as always present but modeled optional or nullable, forcing dead null-handling
  downstream.

Match nullability to the data using the language's optional form, or document the always-present
invariant instead.

| Language | Optional form |
| :--- | :--- |
| Interface definition language | add or drop the required trait |
| Java | `Optional<T>` or the project's nullable annotation |
| Kotlin | `T?` |
| TypeScript | `field?:` or `T \| undefined` |
| Rust | `Option<T>` |
| Go | pointer |
| Python | `Optional[T]` or `T \| None` |

## Do NOT flag

- Fields that are independently and simultaneously present -- not a union.
- A field already typed as a union, sealed type, optional, or nullable-annotated type -- it already
  expresses its shape.
- A structure with no documented mutual-exclusion or optionality invariant in the diff.
- A pre-existing declaration the change did not introduce, a pre-existing structure that merely gains a
  field, or a declaration the change only touches incidentally.
