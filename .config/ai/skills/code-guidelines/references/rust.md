# Rust Standards

## Types

- `#[derive(Debug)]` on all structs/enums; non-Debug types block debugging
- `NewType` for domain primitives: `struct UserId(u64)`
- `NonZero*` for non-zero values
- Enums over booleans when states have distinct behavior
- `Option` for nullable, `Result` for fallible

## Nullability

- `Option<T>` for nullable values
- Pattern match or `?` to propagate; `.unwrap()` only in tests

## Error Handling

- Domain error enums. No `Box<dyn Error>` in public APIs
- `thiserror` for libraries, `anyhow` for binaries
- `?` for propagation; `match` to transform/handle errors
- Avoid panics in library code; use `Result` for recoverable

## Ownership

- Borrow default; clone justified. `&str`/`impl AsRef<str>` in params
- Flexible params: `impl Into<String>`, `impl AsRef<str>`, `impl AsRef<Path>`
- `std::mem::take`/`replace` for ownership transfers
- `Cow<'_, str>` when fn may or may not need to allocate

## Structure

- `impl` blocks: constructors -> public -> private
- Derive order: `Debug, Default, Clone, PartialEq, Eq, Hash, Serialize, Deserialize`
- `#[must_use]` when ignoring return value likely bug

## Patterns

- Builder for complex construction (>3 params or optional fields)
- Type-state for compile-time protocol enforcement
- `From`/`Into` infallible; `TryFrom`/`TryInto` fallible
- Iterator chains over explicit loops when intent clearer

## Testing

- `#[cfg(test)] mod tests` in same file
- Doc tests for public API examples
- `proptest` for algorithmic correctness

## Style

- `rustfmt` defaults; `clippy::pedantic` baseline
- `#[allow(...)]` with reason; no `dbg!` in non-test code
- `pub(crate)` default; `pub` only for API surface
