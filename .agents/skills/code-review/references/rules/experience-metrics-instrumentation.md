# Experience Metrics Instrumentation

A newly-added user interaction or client-side operational branch with business or experience signal emits a named funnel event or custom metric.

## Why

Business and funnel events are the user actions the business measures for adoption and drop-off. A new control or flow shipped without instrumentation keeps that funnel step invisible.

## Diff scope

Flag only an interaction or branch this change adds or modifies. A pre-existing handler on an unchanged context line stays untouched -- adding instrumentation to untouched code widens the change past its purpose.

## Mechanism first

Determine the mechanism the code already uses from diff-visible evidence and phrase the remedy as a call in that mechanism:

- a clickstream or analytics event publisher;
- a product-analytics event call;
- a custom real-user-monitoring event call;
- a project-specific emitter.

Where the changed file shows no mechanism, name the gap rather than inventing an API.

## Flag

### Business-meaningful control handler with no funnel event

A new handler on a business-meaningful control -- submitting a form, completing a checkout or wizard step, creating or saving a resource, confirming or cancelling an action, advancing a multi-step flow -- with no clickstream or funnel event for the action or step anywhere on its call chain.

Trace the call chain visible in the diff first: where the handler delegates to a shared analytics or clickstream hook or utility that already emits this functional event, there is no finding. Emit the funnel event once, at the layer owning the action.

### Critical async operation with no outcome and latency metric

A new data fetch or mutation for a key user flow with no success/failure metric and no client-measured latency for that specific operation. Page-load timing and Core Web Vitals are auto-captured; a specific in-page action's outcome and latency are not.

### Error boundary, catch, or fallback-UI branch with no categorized error count

A new error boundary, catch, or fallback-UI branch with no categorized error-count metric carrying a reason dimension, so a client-side failure of this flow is alarmable.

### Experiment or feature-flag branch with no comparison metric

A new experiment or feature-flag treatment branch with no metric capable of comparing treatment outcomes.

## Every finding states

- the event or metric name and the fields or dimensions it carries;
- whether it is a business or funnel metric, or an experience or operational metric;
- why real-user monitoring does not already capture it;
- the emission call to add, in the mechanism the file uses.

## Do NOT flag

- A funnel event already emitted for this action elsewhere on its call chain. Where the handler delegates to a shared analytics or clickstream hook or utility that already emits the same functional event, a second emission is the defect. The event is emitted once, at the layer owning the action.
- Signals real-user monitoring and client-side metrics capture automatically: Core Web Vitals (Largest Contentful Paint, Interaction to Next Paint or First Input Delay, Cumulative Layout Shift), page-load and navigation timing, the load waterfall, document and navigation and HTTP events, automatically-detected uncaught JavaScript errors and crashes. Never suggest instrumenting page-load latency or web vitals in code.
- An interaction with no business or experience significance: presentational-only state, a styling toggle, opening or closing a tooltip or menu, purely local UI state -- unless it is a tracked funnel step.
- A control that already emits an appropriate clickstream event or metric on an added line.
- Any handler on an unchanged context line.
