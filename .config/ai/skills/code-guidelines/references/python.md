# Python Standards

## Types

- `mypy --strict` or `pyright` basic+; `# type: ignore[error-code]  # reason` when suppressing
- `from __future__ import annotations` for forward ref simplicity
- `NewType` for domain primitives: `UserId = NewType('UserId', int)`
- `TypedDict` for structured dicts; no `dict[str, Any]`
- Discriminated unions via `Literal` field: `type: Literal["success"]`
- `Protocol` for structural typing over ABC when only signatures matter
- `Final` for constants; `ClassVar` for class-level attributes
- `Self` for methods returning instance type (3.11+)
- Prefer `Sequence`, `Mapping`, `Iterable` in params; concrete types in returns

## Nullability

- `T | None` over `Optional[T]` (3.10+ syntax)
- Explicit `None` returns: `def find(...) -> User | None`
- Guard clauses to narrow early; avoid nested `if x is not None`
- No `assert x is not None` for narrowing in production; use explicit checks
- `@overload` to express input-dependent return types

## Mutability

- Immutable defaults: `def f(items: Sequence[T] = ())` not `items: list[T] = []`
- `tuple` over `list` when length/contents fixed
- `frozenset` over `set` for hashable collections
- `@dataclass(frozen=True)` default; mutable with justification
- No mutation of function arguments; return new values

## Error Handling

- Custom exception hierarchy per domain: `class AuthError(AppError)`
- Exception chaining: `raise ValidationError(...) from original`
- `try/except` scoped to minimal lines; no broad `except Exception`
- Log at catch site with context; re-raise or handle, not both

## Structure

- One class per file for significant classes; utilities may group
- `__all__` explicit in modules with public API
- Relative imports within package; absolute from outside
- Class order: `__init__` -> class methods -> public -> private
- `__slots__` for data classes with many instances

## Patterns

- `@dataclass` for data containers; `NamedTuple` for immutable records
- `match` statements (3.10+) for type narrowing and destructuring
- Context managers (`with`) for resource lifecycle
- `functools.cache`/`lru_cache` for pure function memoization
- Generators for lazy sequences; `yield from` for delegation
- Comprehensions over `map`/`filter` when readable; loops when complex
- `async/await` for I/O-bound concurrency; `asyncio.gather` for concurrent ops
- No mixing sync and async I/O; `asyncio.to_thread` to bridge

## Testing

- `pytest` as runner; no `unittest.TestCase` unless framework requires
- Fixtures over setup methods; scope appropriately
- `pytest.raises(ExceptionType, match=r"pattern")` for exceptions
- `pytest.mark.parametrize` for data-driven tests
- `hypothesis` for property-based testing of pure functions

## Style

- `ruff` for linting and formatting
- Google-style docstrings for public API
- f-strings over `.format()` or `%`
- `pathlib.Path` over `os.path`
- `pyproject.toml` as single source of project metadata
