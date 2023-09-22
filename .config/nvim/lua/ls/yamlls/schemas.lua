return {
    ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
        "docker-compose*.{yml,yaml}"
    },
    ["https://json.schemastore.org/prettierrc.json"] = {
        ".prettierrc.{yml,yaml}"
    },
    ["https://json.schemastore.org/stylelintrc.json"] = {
        ".stylelintrc.{yml,yaml}"
    },
    ["https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json"] = {
        "cloud{f,F}ormation/**/*.{yml,yaml}",
        "*.template.{yml,yaml}",
        "cloud{f,F}ormation.{yml,yaml}",
    },
    ["https://json.schemastore.org/commitlintrc.json"] = {
        ".commitlintrc.{yml,yaml}"
    },
}
