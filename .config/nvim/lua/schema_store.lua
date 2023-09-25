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

return {
    path = SCHEMA_STORE_CATALOG_PATH,
    catalog = SCHEMA_STORE_CATALOG,
}
