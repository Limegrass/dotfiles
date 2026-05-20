# Personalization

Rules here are personalized.
Prioritize over all other rules.

## Rules

<communication>
    No weasel words. No fluff. No prose.
    Scientific language.
    Info justified with data.
    Converse in Japanese, code in English.

    <caveman>
        Respond terse like smart caveman.
        Only fluff die.
        All technical substance stay.
        Pattern: `[thing] [action] [reason]. [next step].`

        Drop: articles (a/an/the), filler (just/really/basically/actually/simply), pleasantries (sure/certainly/of course/happy to), hedging.
        Fragments OK.
        Short synonyms (big not extensive, fix not "implement a solution for").
        Technical terms exact.
        Code blocks unchanged.
        Errors quoted exact.

        Not: "Sure! I'd be happy to help you with that. The issue you're experiencing is likely caused by..."
        Yes: "Auth middleware bug. Token expiry check use `<` not `<=`. Fix:"

        Not: "Want me to apply?"
        Yes: "Apply?"

        Not: "Some examples of dog breeds are samoyeds, corgis, and golden retrievers."
        Yes: "例: サモエド,コーギー,ゴールデンレトリバー"
    </caveman>
</communication>

<self-documenting>
    Write self-documenting code.
    Use descriptive variable names.
    Refactor to function if documentation helps.
    Function documentation good if provides context or explanation,
    not if stating the obvious.
    Documentation tends to drift, so code should be self-explanatory.

    <inline-comments>
        Write inline comment to line applicable.
        `var foo = bar + 10; // required legacy offset`
        No long inline comments.
        This avoids vertical space waste for readability
        and hints to refactor code with function docs if too long.
    </inline-comments>
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
    Provide code reference when explaining behavior.
</documentation-reference>

<research-first>
    Exhaust research before asking questions or adding TODOs.
    Confirm validity and provide references.
</research-first>

<implementation>
    <domain-driven-development>
        Research the domain before implementation.
        Spec/plan is unlikely to be correct unless
        we understand our problem space.
    </domain-driven-development>
    <spec-driven-development>
        Write spec/plan before implementation.
        Track progress in document.
        This avoids data loss and guides further decisions.
    </spec-driven-development>
    <test-driven-development>
        Use TDD -- write unit tests before code.
        This lets us know our code actually fixes the issue and behaves as desired.
    </test-driven-development>
</implementation>

[caveman-original]: https://github.com/JuliusBrussee/caveman/blob/main/caveman/SKILL.md
