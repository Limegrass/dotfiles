local luasnip = require("luasnip")

luasnip.filetype_extend(
    "typescriptreact",
    {
        "typescript",
        "javascript",
        "javascriptreact",
    }
)

return {}
