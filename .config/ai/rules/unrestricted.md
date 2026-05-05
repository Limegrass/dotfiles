# Unrestricted usage

Rules for environments without token cost concerns.

## Rules

<spec-driven-development>
    Before implementing, invoke spec-driven-development skill.
    Spec contains: current state (code refs + example data),
    desired state (before/after), affected components, edge cases.
    No code until user reviews spec.
    Store alongside plans. Name: `spec-{feature}.md`.
</spec-driven-development>

<type-understanding>
    Resolve full schema of types being modified before implementation.
    Search workspace, remote repos, or ask user if not found.
    Prevents misuse of fields, wrong nullability, missed constraints.
</type-understanding>

<self-review>
    After completion, delegate review instance.
    Reviewer checks: correctness, edge cases, architecture, style.
</self-review>

<maintainability-correctness-performance>
    For logic changes, delegate three planning perspectives.
    Each invokes a skill: plan-for-maintainability, plan-for-correctness, plan-for-performance.
    Proposed changes only, no modifications.
    Use Claude Opus as model if available.
</maintainability-correctness-performance>
