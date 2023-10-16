package.path = package.path .. ";../?.lua"
local schema_store_catalog = require("schema_store").catalog

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
    {
        fileMatch = {
            ".luarc.json",
        },
        url = "https://raw.githubusercontent.com/sumneko/vscode-lua/master/setting/schema.json"
    },
}

local combined_schemas = vim.tbl_deep_extend("keep", CUSTOM_SCHEMAS, schema_store_catalog["schemas"])

return combined_schemas
