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
}
