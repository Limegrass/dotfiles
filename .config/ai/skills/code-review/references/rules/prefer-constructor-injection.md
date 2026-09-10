# Prefer Constructor Injection

A class managed by an Inversion of Control container receives its collaborators as constructor
parameters.

## Why

- Explicit collaborators: a constructor signature names every dependency the type needs. Field
  injection and in-constructor construction hide them, so callers and reviewers cannot see the
  contract.
- Immutability: constructor-injected dependencies can be `final` / `readonly` / `val`; field injection
  forces mutable, reassignable state.
- Substitutability and testability: an injected collaborator is replaced by a mock or fake in a unit
  test. A field-injected class needs the container or reflection, and a constructor that constructs its
  own collaborator hard-codes the concrete type so it cannot be substituted at all.
- No partially-constructed state: a field-injected object exists with null dependencies between
  construction and injection -- an invalid state the type silently permits.
- Surfaces cycles: constructor injection fails fast on a circular dependency at startup; field
  injection hides the cycle until first use.

## Framework gate

The diff must show a framework signal at the flagged site:

- an injection marker -- `@Inject`, `@Autowired`, `@Resource`, `@inject`, `[Inject]`; or
- a class-level component marker -- `@Injectable`, `@Component`, `@Service`, `@Controller`,
  `@Repository`, `@Singleton`, `@Named`.

Never infer container usage the diff does not show, and never apply this to plain hand-written classes
using no framework. Map the fix to the construct the file's language and framework provide (Guice,
Spring, Dagger, Micronaut, CDI, Angular, NestJS, InversifyJS, tsyringe, Blazor, Symfony, Zenject,
`get_it`/`injectable`).

## Flag

### Injection into a field, property, or setter

A framework injection marker applied to:

- a class field or property:
  - Java or Kotlin: `@Inject private FooClient client;`, `@Autowired Bar bar;`, `@Resource Baz baz;`
  - TypeScript (Angular, NestJS, InversifyJS): `@Inject(TOKEN) private client: FooClient` or
    `@inject(TYPES.Foo) private foo: Foo` declared as a class property
  - C# (Blazor, Zenject): `[Inject] public FooService Foo { get; set; }`
- a setter method: `@Autowired public void setClient(FooClient client) { ... }`,
  `@Inject public void setFoo(Foo foo) { ... }`

### Collaborator constructed inside the constructor

A framework-managed class -- it carries a class-level component marker, or its constructor or another
member carries an injection marker -- whose constructor obtains a collaborator itself instead of
receiving it as a parameter:

- direct instantiation of a service, client, repository, gateway, manager, handler, or other
  injectable: `this.client = new FooClient(...)`;
- a service-locator or static-singleton lookup: `Injector.getInstance(FooClient.class)`,
  `context.getBean(FooClient.class)`, `container.resolve(...)`, `SomeSingleton.getInstance()`.

## Remedy

Accept the collaborator as a constructor parameter, let the container provide it (binding it in a
module where the framework requires that), assign it to a `final` / `readonly` field, and remove the
field-level marker or the in-constructor construction.

```java
// before -- collaborator constructed inside the constructor
@Injectable
public class OrderService {
    private final PaymentClient client;
    public OrderService() {
        this.client = new PaymentClient();   // hard-wired collaborator
    }
}

// after
@Injectable
public class OrderService {
    private final PaymentClient client;

    @Inject
    public OrderService(PaymentClient client) {   // container supplies it; substitutable in tests
        this.client = client;
    }
}
```

## Do NOT flag

- Constructor injection -- the marker on a constructor or its parameters
  (`@Inject public Service(FooClient client)`), or a single constructor whose parameters the container
  resolves with no marker. This is the recommended form.
- Class or component declarations: `@Injectable`, `@Component`, `@Service`, `@Named`, `@Singleton` on
  the type. They register the bean; they are not an injection site.
- Container wiring and configuration: `@Provides` methods, `bind(...).to(...)`, `AbstractModule` and
  module classes.
- Framework lifecycle or factory methods the framework can satisfy only by method injection.
- Constructing things that are not injected collaborators inside the constructor:
  - value objects, data holders, DTOs, config records (`new Config(timeout)`);
  - collections and buffers (`new ArrayList<>()`, `new HashMap<>()`, `new StringBuilder()`);
  - builders, and objects built purely from the constructor's own parameters (`new Wrapper(param)` --
    adapting injected input, not hard-wiring a dependency).
- Classes with no framework signal in the diff.
