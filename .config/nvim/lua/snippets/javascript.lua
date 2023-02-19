local absolute_indexer = require("luasnip.nodes.absolute_indexer")

local get_module_var_name = function(import_path)
    local import_parts = vim.split(import_path, "/", { plain = true })
    local raw_module_name = import_parts[#import_parts]
    return string.gsub(raw_module_name, "%W", "")
end

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
    snippet(
        "import",
        fmt("import {import_name} from \"{import_path}\";", {
            import_name = choice_node(2, {
                fmt("{{ {} }}", {
                    insert_node(1),
                }),
                dynamic_node(
                    nil,
                    function(args)
                        local import_path = args[1][1]
                        local module_name = get_module_var_name(import_path)
                        return snippet_node(nil, insert_node(1, module_name))
                    end,
                    { 1 }
                ),
                fmt("* as {import_name}", {
                    import_name = dynamic_node(
                        1,
                        function(args)
                            local import_path = args[1][1]
                            local module_name = get_module_var_name(import_path)
                            return snippet_node(nil, insert_node(1, module_name))
                        end,
                        { absolute_indexer[1] }
                    ),
                }),
            }),
            -- req default else no cmp suggestions
            import_path = insert_node(1, "module_name"),
        })
    ),
}
