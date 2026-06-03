# TypeScript Standards

## Types

- `strict: true` baseline in tsconfig
- Interface when declaration merging needed; type otherwise
- No `any`. `unknown` + type guard at boundaries only
- Discriminated unions over optional fields when variants have distinct shapes
- `readonly` default; mutable with justification
- Branded types: `type UserId = string & { readonly __brand: unique symbol }`
- `as const` objects or discriminated unions over enums; string enums if enum required
- `Record<K, V>` over `{ [key: K]: V }` index signatures

## Nullability

- `strictNullChecks: true` (non-negotiable)
- `T | undefined` for optional presence; `T | null` for explicit absence
- At JSON boundaries, use `T | null` consistently (JSON has no `undefined`)
- No `!` non-null assertion except test setup or post-filter where TS can't track narrowing (add comment)
- Optional chaining (`?.`) over manual null checks

## Mutability

- `readonly` and `Readonly<T>` on properties/arrays by default
- `readonly T[]` or `ReadonlyArray<T>` for immutable arrays
- Mutation only when performance requires with justification

## Error Handling

- Typed error results over thrown exceptions for expected failures
- Discriminated union `{ ok: true; data: T } | { ok: false; error: E }` for typed results
- `try/catch` only at boundaries (API handlers, event listeners)
- Type Promise rejections: prefer Result pattern over untyped catch

## Structure

- Named exports; default only for framework requirements (React pages)
- Barrel files (`index.ts`) only at package boundaries
- Co-locate tests: `foo.ts` -> `foo.test.ts`

## Patterns

- `as const` for literal types
- `satisfies` for type checking without widening
- Exhaustive switch via `never` in default
- Zod/io-ts at boundaries for runtime validation matching static types

## Testing

- Names: `it('should [behavior] when [condition]')`
- Arrange-Act-Assert structure
- No conditional logic in tests; `test.each` for parameterized

## Style

- ESLint + Prettier baseline
- `async/await` over Promises; `.then()` acceptable for simple `Promise.all` transforms
- `void` return type for no return; `undefined` for explicit undefined return
