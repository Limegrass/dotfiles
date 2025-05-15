return {
    {
        "saghen/blink.cmp",
        dependencies = {
            "neovim/nvim-lspconfig",
            "L3MON4D3/LuaSnip",
            "onsails/lspkind.nvim",
            "brenoprata10/nvim-highlight-colors",
            "saecki/crates.nvim", -- functionality appears degraded, but it supposedly should work
            -- https://github.com/alexandre-abrioux/blink-cmp-npm.nvim -- new project, need to review code
        },
        version = "1.*",

        ---@module "blink.cmp"
        ---@type blink.cmp.Config
        opts = {
            appearance = {
                kind_icons = require("lsp-kind-icons")
            },

            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                },
                menu = {
                    draw = {
                        columns = {
                            { "label",       "label_description", gap = 1 },
                            { "kind_icon", },
                            { "source_name", }
                        },
                        components = {
                            kind_icon = {
                                text = function(ctx)
                                    local icon = ctx.kind_icon
                                    if ctx.item.source_id == "lsp" then
                                        local color_item = require("nvim-highlight-colors").format(
                                            ctx.item.documentation,
                                            { kind = ctx.kind }
                                        )
                                        if color_item and color_item.abbr ~= "" then
                                            icon = color_item.abbr
                                        end
                                    end
                                    return icon .. ctx.icon_gap
                                end,
                                highlight = function(ctx)
                                    local highlight = "BlinkCmpKind" .. ctx.kind
                                    if ctx.item.source_id == "lsp" then
                                        local color_item = require("nvim-highlight-colors").format(
                                            ctx.item.documentation,
                                            { kind = ctx.kind })
                                        if color_item and color_item.abbr_hl_group then
                                            highlight = color_item.abbr_hl_group
                                        end
                                    end
                                    return highlight
                                end,
                            },
                            -- TODO: Highlighting the kind_icon by source type could be a more compact way to express it
                            source_name = {
                                text = function(ctx)
                                    local source_name_map = {
                                        buffer = "[Buf]",
                                        lsp = "[LSP]",
                                        snippets = "[Snip]",
                                    }
                                    return source_name_map[ctx.source_id] or ctx.source_name
                                end,
                            },
                        },
                    },
                },
                ghost_text = {
                    enabled = true,
                },
            },

            fuzzy = {
                implementation = "prefer_rust",
            },

            -- :h blink-cmp-config-keymap
            keymap = {
                preset = "default",
                ["<C-space>"] = { "show", "show_documentation", "show_signature", "fallback", },
                ["<C-e>"] = { "hide" },
                ["<C-y>"] = { "select_and_accept" },
                ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
                ["<C-n>"] = { "select_next", "fallback_to_mappings" },
                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },
                ["<Tab>"] = { "select_and_accept", "fallback" },
                ["<C-k>"] = { "snippet_backward", "show_signature", "fallback" },
                ["<C-j>"] = { "snippet_forward", "fallback" },
                ["<C-l>"] = {
                    function()
                        local luasnip = require("luasnip")
                        if luasnip.choice_active() then
                            vim.schedule(function()
                                luasnip.change_choice(1)
                            end)
                            return true
                        end
                        return false
                    end,
                    "fallback"
                },
            },

            signature = {
                enabled = true,
            },

            snippets = {
                preset = "luasnip",
            },

            sources = {
                default = {
                    "lazydev",
                    "lsp",
                    "path",
                    "snippets",
                    "buffer", -- TODO: see if buffers can only show visible buffers
                },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100, -- make lazydev completions top priority
                    },
                },
            },
        },
        opts_extend = { "sources.default" },
        config = function(_, opts)
            local blink = require("blink.cmp")
            blink.setup(opts)

            local on_attach = require("lsp-on-attach").on_attach_default
            local language_servers = require("lspconfig-overrides").language_servers

            local keymap_opts = { noremap = true, silent = true }
            vim.keymap.set("n", "[k", vim.diagnostic.goto_prev, keymap_opts)
            vim.keymap.set("n", "]k", vim.diagnostic.goto_next, keymap_opts)
            vim.keymap.set("n", "<space>k", vim.diagnostic.open_float, keymap_opts)
            vim.keymap.set("n", "<space>K", vim.diagnostic.setloclist, keymap_opts)

            local lspconfig = require("lspconfig")
            local default_capabilities = blink.get_lsp_capabilities(
                vim.lsp.protocol.make_client_capabilities()
            )

            for lsp, options in pairs(language_servers) do
                if options.condition == nil or options.condition then
                    if vim.fn.has("nvim-0.11") then
                        vim.lsp.config(lsp,
                            {
                                capabilities = blink.get_lsp_capabilities(),
                                on_attach = options.on_attach or on_attach,
                            })
                        vim.lsp.enable(lsp)
                    else
                        options.capabilities = options.capabilities or default_capabilities
                        options.on_attach = options.on_attach or on_attach
                        lspconfig[lsp].setup(options)
                    end
                end
            end
        end,
    }
}
