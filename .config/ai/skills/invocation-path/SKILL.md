---
name: invocation-path
description: >
  Documents code invocation flows with dual output: a compact flow overview
  for quick scanning and detailed annotated method bullets for deep analysis.
  Invoke for all code documentation, analysis, or investigation tasks.
---

# Invocation Path

Dual-output: Flow Overview (shape) + Detailed Trace (depth).

## Flow Overview

```markdown
## Flow Overview

Stage 1: RequestHandler (entry point)
  Handler.handle(event)
    ├── Validator.validate(request)
    ├── Service.process(id)
    │   ├── Repository.fetch(id)
    │   └── Transformer.apply(entity) -> [WRITE: database]
    └── Publisher.emit(event) -> [WRITE: queue]

Stage 2: EventProcessor (async consumer)
  Processor.onEvent(message)
    └── Notifier.send(notification) -> [WRITE: external API]
```

- `-> [EFFECT]` suffix marks side effects
- Shape only -- no links, no explanations
- Omit trivial delegation unless it branches

## Detailed Trace

```markdown
### Stage 1: RequestHandler (entry point)

Entry: HTTP POST /resource

- `Handler.handleRequest(Event)`
  [Handler.java L30-L45](<permalink>)
  Entry point. Deserializes event, loops over records.

  - `Service.processItem(itemId)` -- BRANCH: type == UPDATE; KEY: missing validation
    [Service.java L60-L80](<permalink>)
    Dispatches based on event type.

    - `Repository.save(entity)` -- SIDE EFFECT: database write
      [Repository.java L45-L55](<permalink>)

    - `Publisher.emit(event)` -- SIDE EFFECT: queue publish
      [Publisher.java L20-L25](<permalink>)

Trigger: HTTP request
Effects: database write, queue publish
Skips: empty payload
```

### Conventions

- **Stage header**: `### Stage N: Name (purpose)` + `Entry:` line. Group by logical boundary.
- **Bullet format**: method signature -> source link -> explanation (optional for simple delegation).
- **Annotations**: append `-- TYPE: detail` on method line. Chain: `-- TYPE: x; TYPE: y`
- **Annotation types**: `SIDE EFFECT`, `BRANCH`, `KEY`, `SKIP`, `CATCH`
- **Source links**: `[File.java L50-L60](<url>#L50-L60)`. Pin to commit for investigations.
- **Stage summary**: `Trigger` / `Effects` / `Skips` block at end of each stage.

## Rules

- Overview before detail. Readers orient on shape, then drill into specifics.
- Source link on every method in detailed trace. Without links, trace decays into guesswork.
- Explanation required for entry points and key behaviors. Simple delegation self-documents via method name.
- Annotations on method line, not in explanation. Keeps them scannable when skimming bullets.
- Overview omits trivial methods. Getters/constructors add noise without structural insight.
- Adapt freely. Skip stages if single-component. Merge overview into trace if flow is <5 methods.
