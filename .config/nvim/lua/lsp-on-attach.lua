function FORMAT_FILTER(client)
    local null_ls = require("null-ls")
    local null_ls_formatting_sources = null_ls.get_source({
        method = null_ls.methods.FORMATTING,
    })

    local buf_has_null_ls_formatter = false

    for _, source in ipairs(null_ls_formatting_sources) do
        buf_has_null_ls_formatter = buf_has_null_ls_formatter or
            source.filetypes[vim.bo.filetype]
    end

    if buf_has_null_ls_formatter then
        -- always use only null-ls if formatting source attached
        return client.name == "null-ls"
    else
        -- fallback to allow anything
        return true
    end
end

function ON_ATTACH_ENABLE_FORMAT_ON_WRITE(client, bufnr)
    if client.supports_method("textDocument/formatting") then
        local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                local is_format_on_save_disabled = vim.g[client.name .. ":format_on_save"] == false
                if not is_format_on_save_disabled then
                    vim.lsp.buf.format({
                        bufnr = bufnr,
                        timeout_ms = 200,
                        filter = FORMAT_FILTER,
                    })
                end
            end,
        })
    end
end

function ON_ATTACH_SET_LSP_BINDS(_, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "<space>gd", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "<space>gi", vim.lsp.buf.implementation, bufopts)

    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set("n", "<space>fr", vim.lsp.buf.references, bufopts)

    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<space>aa", vim.lsp.buf.code_action, bufopts)

    vim.keymap.set("n", "<space>=", function()
        vim.lsp.buf.format({
            async = true,
            filter = FORMAT_FILTER,
        })
    end, bufopts)

    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr(#{timeout_ms:250})")
end

function ON_ATTACH_DEFAULT(client, bufnr)
    ON_ATTACH_SET_LSP_BINDS(client, bufnr)
    ON_ATTACH_ENABLE_FORMAT_ON_WRITE(client, bufnr)
end

return {
    on_attach_default = ON_ATTACH_DEFAULT,
    on_attach_enable_format_on_write = ON_ATTACH_ENABLE_FORMAT_ON_WRITE,
}
