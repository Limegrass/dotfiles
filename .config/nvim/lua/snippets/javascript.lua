local absolute_indexer = require("luasnip.nodes.absolute_indexer")

local get_module_var_name = function(import_path)
    local import_parts = vim.split(import_path, "/", { plain = true })
    local raw_module_name = import_parts[#import_parts]
    return string.gsub(raw_module_name, "%W", "")
end

local get_array_for_element_snippet = function(function_name)
    return postfix("." .. function_name, {
        dynamic_node(1,
            function(_, parent)
                return snippet_node(nil,
                    fmt(parent.snippet.env.POSTFIX_MATCH ..
                        "." .. function_name .. "(({map_args}) => {body})", {
                        map_args = choice_node(1, {
                            insert_node(nil, "item"),
                            fmt("{{ {properties} }}", {
                                properties = insert_node(1, "properties"),
                            }),
                            fmt("{item}, {index}", {
                                item = insert_node(1, "item"),
                                index = insert_node(2, "index")
                            }),
                            fmt("{{ {properties} }}, {index}", {
                                properties = insert_node(1, "properties"),
                                index = insert_node(2, "index")
                            }),
                        }),
                        body = choice_node(2, {
                            insert_node(nil, "true"),
                            fmt("{{ {body} }}", {
                                body = insert_node(1),
                            }),
                            fmt("({{ {body} }})", {
                                body = insert_node(1),
                            }),
                        }),
                    })
                )
            end,
            {}
        ),
    })
end

local jsdoc_typedef_import = snippet(
    "jsdoc_typedef_import",
    fmta("/** @typedef {import(\"<module_name>\").<component>} <import> */", {
        module_name = insert_node(1),
        component = dynamic_node(2,
            function(nodes)
                local import_path = nodes[1][1]
                local module_name = get_module_var_name(import_path)
                return snippet_node(nil,
                    choice_node(1, {
                        insert_node(nil, module_name),
                        insert_node(nil, "default"),
                    })
                )
            end,
            { 1 }
        ),
        import = dynamic_node(3,
            function(nodes)
                local import_name = nodes[1][1]
                return snippet_node(nil, insert_node(1, import_name))
            end,
            { 2 }
        ),
    })
)

local jsdoc_type = snippet(
    "jsdoc_type",
    fmta("/** @type {<type_name>} */", {
        type_name = insert_node(1),
    })
)

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

    postfix(".reduce", {
        dynamic_node(1,
            function(_, parent)
                return snippet_node(nil,
                    fmt(parent.snippet.env.POSTFIX_MATCH ..
                        ".reduce(({reduce_args}) => {body}, {initial_state})", {
                        initial_state = insert_node(1, "{}"),
                        reduce_args = choice_node(2, {
                            fmt("{}, {}", {
                                insert_node(1, "accumulator"),
                                insert_node(2, "currentValue"),
                            }),
                            fmt("{}, {}, {}", {
                                insert_node(1, "accumulator"),
                                insert_node(2, "currentValue"),
                                insert_node(3, "index"),
                            }),
                        }),
                        body = choice_node(3, {
                            insert_node(1),
                            fmt("{{{body}}}", {
                                body = insert_node(1),
                            }),
                            fmt("({{ {body} }})", {
                                body = insert_node(1),
                            }),
                        }),
                    })
                )
            end,
            {}
        ),
    }),

    get_array_for_element_snippet("forEach"),
    get_array_for_element_snippet("map"),
    get_array_for_element_snippet("filter"),
    get_array_for_element_snippet("find"),

    jsdoc_typedef_import,
    jsdoc_type
}
