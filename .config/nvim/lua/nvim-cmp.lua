return {
    {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
            opts.sources = opts.sources or {}
            table.insert(opts.sources, {
                name = "lazydev",
                group_index = 0, -- set group index to 0 to skip loading LuaLS completions
            })
        end,
        dependencies = {
            "onsails/lspkind.nvim",
            "neovim/nvim-lspconfig",
            "L3MON4D3/LuaSnip",
            "brenoprata10/nvim-highlight-colors",
            "saecki/crates.nvim",
            "David-Kunz/cmp-npm",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
        },
        config = function()
            local cmp = require("cmp")
            local lspconfig = require("lspconfig")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            cmp.setup({
                formatting = {
                    expandable_indicator = true,
                    fields = { 'abbr', 'kind', 'menu' },
                    format = function(entry, item)
                        local color_item = require("nvim-highlight-colors").format(entry, { kind = item.kind })
                        item = lspkind.cmp_format({
                            mode = "symbol",
                            menu = ({
                                buffer = "[Buf]",
                                nvim_lsp = "[LSP]",
                                luasnip = "[Snip]",
                            }),
                            symbol_map = require("lsp-kind-icons"),
                        })(entry, item)
                        if color_item.abbr_hl_group then
                            item.kind_hl_group = color_item.abbr_hl_group
                            item.kind = color_item.abbr
                        end
                        return item
                    end,
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete({}),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.confirm({ select = true })
                        else
                            fallback() -- fallback sends existing mapping
                        end
                    end, { "i", "s" }),
                    ["<C-j>"] = cmp.mapping(function(fallback)
                        if luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback() -- fallback sends existing mapping
                        end
                    end, { "i", "s" }),
                    ["<C-k>"] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-l>"] = cmp.mapping(function(fallback)
                        if luasnip.choice_active() then
                            luasnip.change_choice(1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "crates",  keyword_length = 4 },
                    { name = "npm",     keyword_length = 4 },
                }, {
                    { name = "path" },
                    {
                        name = 'buffer',
                        option = {
                            get_bufnrs = function()
                                local bufs = {}
                                for _, win in ipairs(vim.api.nvim_list_wins()) do
                                    bufs[vim.api.nvim_win_get_buf(win)] = true
                                end
                                return vim.tbl_keys(bufs)
                            end
                        }
                    }
                })
            })

            local cmdlineMapping = cmp.mapping.preset.cmdline({
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if vim.fn.pumvisible() == 1 then
                        local next_key = vim.api.nvim_replace_termcodes("<C-n>", true, false, true)
                        vim.api.nvim_feedkeys(next_key, "c", false)
                    elseif cmp.visible() then
                        cmp.select_next_item()
                    else
                        cmp.complete()
                        fallback()
                    end
                end, { "c" }),
                ["<C-y>"] = {
                    c = function(fallback)
                        if vim.fn.pumvisible() == 1 or not cmp.visible() then
                            fallback()
                        else
                            cmp.confirm({ select = true })
                        end
                    end,
                },
            })

            -- Use buffer source for `/` and `?`
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmdlineMapping,
                sources = {
                    { name = "buffer" }
                }
            })

            -- Use cmdline & path source for ":"
            cmp.setup.cmdline(":", {
                mapping = cmdlineMapping,
                sources = cmp.config.sources({
                    { name = "path" }
                }, {
                    { name = "cmdline", option = { ignore_cmds = { "Man", "!", "edit", "write", } } }
                })
            })

            local opts = { noremap = true, silent = true }
            vim.keymap.set("n", "[k", vim.diagnostic.goto_prev, opts)
            vim.keymap.set("n", "]k", vim.diagnostic.goto_next, opts)
            vim.keymap.set("n", "<space>k", vim.diagnostic.open_float, opts)
            vim.keymap.set("n", "<space>K", vim.diagnostic.setloclist, opts)

            local capabilities = require("cmp_nvim_lsp").default_capabilities(
                vim.lsp.protocol.make_client_capabilities()
            )

            local language_servers = require("lspconfig-overrides").language_servers
            local on_attach = require("lsp-on-attach").on_attach_default
            for lsp, options in pairs(language_servers) do
                if options.condition == nil or options.condition then
                    options.capabilities = options.capabilities or capabilities
                    options.on_attach = options.on_attach or on_attach
                    lspconfig[lsp].setup(options)
                end
            end
        end,
    },

    {
        "David-Kunz/cmp-npm",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("cmp-npm").setup({})
        end
    },
    { "saadparwaiz1/cmp_luasnip" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
}
