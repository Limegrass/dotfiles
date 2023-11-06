local conditions = require("luasnip.extras.conditions")
local conditions_show = require("luasnip.extras.conditions.show")

local line_begin_show_condition = conditions.make_condition(function(line_to_cursor)
    return string.match(line_to_cursor, "%s") == nil
end)

local is_only_trigger = line_begin_show_condition + conditions_show.line_end

local try_except_node = fmt([[
try:
	{}
except:
	{}
]], {
    insert_node(1, "pass"),
    insert_node(0, "pass"),
})

local try_except_finally_node = fmt([[
try:
	{}
except:
	{}
finally:
	{}
]], {
    insert_node(1, "pass"),
    insert_node(2, "pass"),
    insert_node(0, "pass"),
})

local try_except_snippet = snippet(
    "try_except",
    choice_node(1, {
        try_except_node,
        try_except_finally_node,
    })
)

local lambda_snippet = snippet("lambda", {
    unpack(fmt("lambda {}: {}", {
        insert_node(1, "params"),
        insert_node(0, "expr"),
    }))
})

local with_as_node = fmt([[
with {context} as {ident}:
	{body}
]], {
    context = choice_node(1, {
        insert_node(nil, "context"),
        fmt("open(\"{}\")", { insert_node(1, "file_path") }),
    }),
    ident = insert_node(2, "ident"),
    body = insert_node(0, "pass"),
})

local with_as_snippet = snippet("with_as", with_as_node)

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
    try_except_snippet,
    lambda_snippet,
    with_as_snippet,
}
