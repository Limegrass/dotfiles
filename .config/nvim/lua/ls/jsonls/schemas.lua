local SCHEMA_STORE_CATALOG_PATH = vim.env.VIMLOCAL .. "/schemastore.catalog.json"
if vim.fn.filereadable(SCHEMA_STORE_CATALOG_PATH) == 0 and vim.fn.executable("curl") > 0 then
    vim.fn.system({
        "curl",
        "--output",
        SCHEMA_STORE_CATALOG_PATH,
        "https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/api/json/catalog.json",
    })
end

if vim.fn.filereadable(SCHEMA_STORE_CATALOG_PATH) > 0 then
    local file_content_lines = vim.fn.readfile(SCHEMA_STORE_CATALOG_PATH)
    local file_content = vim.fn.join(file_content_lines, "")
    SCHEMA_STORE_CATALOG = vim.json.decode(file_content) or { schemas = {} }
end

local CUSTOM_SCHEMAS = {
    {
        fileMatch = {
            "package.json"
        },
        url = "https://json.schemastore.org/package.json"
    },
    {
        fileMatch = {
            "*tsconfig*.json"
        },
        url = "https://json.schemastore.org/tsconfig.json"
    },
    {
        fileMatch = {
            "*jsconfig*.json"
        },
        url = "https://json.schemastore.org/jsconfig.json"
    },
    {
        fileMatch = {
            ".prettierrc",
            ".prettierrc.json",
            "prettier.config.json"
        },
        url = "https://json.schemastore.org/prettierrc.json"
    },
    {
        fileMatch = {
            ".eslintrc",
            ".eslintrc.json"
        },
        url = "https://json.schemastore.org/eslintrc.json"
    },
    {
        fileMatch = {
            ".babelrc",
            ".babelrc.json",
            "babel.config.json"
        },
        url = "https://json.schemastore.org/babelrc.json"
    },
    {
        fileMatch = { "lerna.json" },
        url = "https://json.schemastore.org/lerna.json"
    },
    {
        fileMatch = {
            "cloud{f,F}ormation/**/*.json",
            "*.template.json",
            "cloud{f,F}ormation.json",
        },
        url = "https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json"
    },
    {
        fileMatch = {
            ".stylelintrc",
            ".stylelintrc.json",
            "stylelint.config.json"
        },
        url = "https://json.schemastore.org/stylelintrc.json"
    },
    {
        fileMatch = {
            ".commitlintrc",
            ".commitlintrc.{json,jsonc}"
        },
        url = "https://json.schemastore.org/commitlintrc.json"
    },
}

return vim.tbl_deep_extend("keep", CUSTOM_SCHEMAS, SCHEMA_STORE_CATALOG["schemas"])
