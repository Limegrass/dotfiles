# Personalization

Rules here are personalized.
Prioritize over all other rules.

## Rules

<communication>
    No weasel words. No fluff. Caveman mode.
    Scientific and precise language.
    Words must be justifiable with data.
    Prose is unnecessary.
</communication>

<self-documenting>
    Write self-documenting code.
    No long inline comments.
    Use descriptive variable names.
    Refactor to function if documentation helps.
    Function documentation good if provides context or explanation,
    not if stating the obvious.
</self-documenting>

<strict-types>
    Define narrow types.
    Define nullability when language permits.
    No `any`, `object`, `list`, etc.
</strict-types>

<commit-sanitation>
    1 change type per commit.
    Split change to refactor, feature addition, etc.
    Plan changes with conventional commits.
    Prioritize refactors and fixes before features.
</commit-sanitation>

<white-space>
    Include newlines/whitespace for logical separation.
</white-space>

<markdown-formatting>
    Use md headings and md link definitions.
    Md definitions don't render; comments not headings for link definitions categorization.
    Bold and italics are for emphasis, not titling; minimize usage.
    Definition lists use backtick-colon pattern: `Term`: description.
    Avoid unicode beyond natural language (CJK, etc).
    `--` not `—`, `->` not `→`, `^2` not `²`
</markdown-formatting>

<no-git-commits>
    No git operation execution. Suggested commands OK.
</no-git-commits>

<search-file-content>
    Use `rg -C ${surrounding_context_line_count}` to find matches.
    Only get partial content if full content is undesirable.
    Prefer `rg` over `grep`, `sed`, `head`, `tail` to view partial content.
</search-file-content>

<persisted-scripts>
    Persist scripts to disk.
    Use Python not shell for data analysis.
</persisted-scripts>

<parameterization>
    Use parameterization over scoped variables.
    Applies to all code, even scripts.
</parameterization>

<code-purpose>
    Code exists for humans to read and evolve.
    Prioritize readability and extensibility unless prompted for performance.
    Report implementation trade-offs.
</code-purpose>

<documentation-reference>
    Documentation must have links references.
    Reference always required if one can ask to "prove it".
</documentation-reference>

<plan-documentation>
    Track implementation in a document.
</plan-documentation>
