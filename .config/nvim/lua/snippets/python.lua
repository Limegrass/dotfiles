local conditions = require("luasnip.extras.conditions")
local conditions_show = require("luasnip.extras.conditions.show")

local line_begin_show_condition = conditions.make_condition(function(line_to_cursor)
    return string.match(line_to_cursor, "%s") == nil
end)

local is_only_trigger = line_begin_show_condition + conditions_show.line_end

return {
    snippet("__main__", {
        indent_snippet_node(
            1,
            text_node({ "if __name__ == \"__main__\":", "" }),
            "$PARENT_INDENT\t"
        )
    }, {
        show_condition = is_only_trigger
    }),
    snippet(
        "module_path_add",
        fmt("sys.path.append(\"{path}\")", {
            path = insert_node(1),
        })
    ),
    snippet(
        "from",
        fmt("from {module} import {value}", {
            module = insert_node(1),
            value = insert_node(0),
        })
    ),
}
