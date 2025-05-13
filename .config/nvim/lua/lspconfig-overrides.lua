-- Customizations used on top of neovim/nvim-lspconfig
-- condition sets whether the server is setup for the local server
local language_servers = {
    bashls = {},
    dotls = {},
    smithy_ls = {},
    cssls = {},
    eslint = {},
    gopls = {},
    html = {},
    jdtls = {},
    jsonls = {
        filetypes = { "json", "jsonc" },
        settings = {
            json = {
                schemas = require("ls.jsonls.schemas"),
            }
        }
    },
    kotlin_language_server = {},
    marksman = {},
    omnisharp = {
        cmd = { "omnisharp" }
    },
    powershell_es = {
        condition = vim.fn.executable("pwsh") == 1
    },
    pyright = {},
    lua_ls = {
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" }
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
                    }
                },
            },
        },
    },
    ts_ls = {},
    vimls = {},
    yamlls = {
        settings = {
            yaml = {
                schemaStore = {
                    enable = true,
                    url = "file://" .. require("schema_store").path
                },
                schemas = require("ls.yamlls.schemas"),
            }
        }
    },
    zls = {},
}

return {
    language_servers = language_servers
}
