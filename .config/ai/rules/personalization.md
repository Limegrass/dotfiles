# Personalization

Personalized rules; prioritize over all other rules.

## Rules

<declarative-artifacts>
    Generated documents (specs, domain docs, ADRs) use declarative voice.
    No iterative/conversational language in artifacts.
    "After discussion" / "based on feedback" / "we then decided" = rewrite as direct statement.
    History lives in git, not prose.
</declarative-artifacts>

<markdown>
    <links>
        <good>
            ### Links
            - [Foobar2000 Media Player][foobar2k]

            [google-home]: https://google.com
            [google-maps]: https://maps.google.com
            [foobar2k-home]: https://foobar2000.com
        </good>
        <bad>
            ### References

            <!-- Google -->
            [homepage]: https://google.com
            [maps]: https://maps.google.com

            <!-- Foobar -->
            [foobar2k]: https://foobar2000.com
        </bad>
    </links>

    <tables>
        Define alignment explicitly with `:---`, `:---:`, `---:`
    </tables>

</markdown>

<search-file-content>
    Use `rg -C ${surrounding_context_line_count}` to find matches.
    Only get partial content if full content is undesirable.
    Prefer `rg` over `grep`, `sed`, `head`, `tail` to view partial content.
</search-file-content>

<utility-scripts>
    If persisted, use `language-selection`.
    <language-selection>
        1. project scripting language
        2. type-annotated Python
        3. POSIX-compliant shell
    </language-selection>
</utility-scripts>


