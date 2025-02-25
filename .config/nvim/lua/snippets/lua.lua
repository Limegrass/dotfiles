return {
    snippet(
        "require",
        fmt(
            "local {} = require(\"{}\")",
            {
                insert_node(1, "default"),
                repeat_node(1),
            }
        )
    ),
    snippet(
        "map",
        fmta(
            "vim.keymap.set(<mode>, \"<keybind>\", <fn>, {<opts>})",
            {
                mode = choice_node(1, {
                    fmta("\"<mode>\"", { mode = insert_node(1) }),
                    fmta("{ <mode> }", {
                        mode = insert_node(1),
                    }),
                }),
                keybind = insert_node(2, "keybind"),
                fn = choice_node(3, {
                    insert_node(nil, "fn"),
                    fmta("function() <fn_def> end", {
                        fn_def = insert_node(1, "fn_def"),
                    }),
                }),
                opts = insert_node(4, nil),
            }
        )
    ),
}
