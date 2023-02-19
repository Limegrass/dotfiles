return {
    snippet(
        "describe",
        fmt("describe(\"{}\", () => {{\n\t{}\n}});", {
            dynamic_node(
                1,
                function(_, parent)
                    local filename = parent.env.TM_FILENAME or ""
                    local filename_parts = vim.split(filename, ".", { plain = true })
                    local module_name = filename_parts[1]
                    return snippet_node(nil, insert_node(1, module_name))
                end,
                {}
            ),
            insert_node(0),
        })
    ),
    snippet(
        "it",
        choice_node(
            1,
            {
                fmt("it(\"{}\", async () => {{\n\t{}\n}});", {
                    insert_node(1),
                    insert_node(2),
                }),
                fmt("test(\"{}\", async () => {{\n\t{}\n}});", {
                    insert_node(1),
                    insert_node(2),
                }),
            }
        )
    ),
    snippet(
        "each",
        choice_node(
            1,
            {
                fmt("beforeEach(() => {{\n\t{}\n}});", {
                    insert_node(1),
                }),
                fmt("afterEach(() => {{\n\t{}\n}});", {
                    insert_node(1),
                }),
            }
        )
    ),
}
