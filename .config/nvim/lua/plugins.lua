return {
    { "tpope/vim-fugitive" },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                current_line_blame = true,
                current_line_blame_opts = {
                    delay = 500,
                },
            })
        end,
    },
    { "rhysd/git-messenger.vim" },
    { "tpope/vim-surround" },
    { "tpope/vim-abolish" },
    { "tpope/vim-repeat" },
    { "tpope/vim-unimpaired" },
    { "tpope/vim-scriptease" },
    { "wellle/targets.vim" },
    { "kana/vim-textobj-user" },
    {
        "Julian/vim-textobj-variable-segment",
        branch = "main",
        dependencies = { "kana/vim-textobj-user" },
    },
    {
        "andymass/vim-matchup",
        event = "VimEnter",
    },
    { "michaeljsmith/vim-indent-object" },
    { "godlygeek/tabular" },

    {
        "sjl/gundo.vim",
        cmd = { "GundoToggle", "GundoShow" },
        config = function()
            vim.g.gundo_prefer_python3 = 1
        end,
    },

    {
        "moll/vim-bbye",
        config = function()
            vim.cmd([[
                command! -bang -complete=buffer -nargs=? Bclose Bdelete<bang> <args>
                nnoremap <silent> ZD :Bdelete<CR>
            ]])
        end,
    },

    {
        "tpope/vim-commentary",
        config = function()
            vim.cmd([[
                augroup commentary
                autocmd!
                autocmd FileType sql setlocal commentstring=--\ %s
                autocmd FileType cs setlocal commentstring=//\ %s
                augroup END
                nnoremap <silent> <space><Tab> :Commentary<CR>
                xnoremap <silent> <space><Tab> :Commentary<CR>
            ]])
        end,
    },

    {
        "tpope/vim-dispatch",
        lazy = true,
        cmd = { "Dispatch", "Make", "Focus", "Start" },
    },

    { "roxma/vim-tmux-clipboard" },
    {
        "voldikss/vim-floaterm",
        cmd = { "FloatermToggle" },
        init = function()
            vim.cmd([[
                nnoremap <silent> <space>t :FloatermToggle<CR>
                nnoremap <silent> <space>rs :FloatermSend<CR>
                xnoremap <silent> <space>rs :FloatermSend<CR>
                command! PythonRepl FloatermNew name=python_repl width=0.3 position=bottomright python
                augroup floaterm
                autocmd!
                autocmd FileType floaterm tnoremap <silent> <buffer> <C-J> <C-\><C-N>:FloatermToggle<CR>
                augroup END
            ]])
        end,
    },

    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
    },
    { "nvim-telescope/telescope-symbols.nvim" },
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-symbols.nvim"
        },
        config = function()
            local telescope = require("telescope")
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<c-space><c-space>", function()
                local is_rg_available = vim.fn.executable("rg") == 1
                local find_files_options = is_rg_available
                    and { find_command = { "rg", "--files", "--hidden", "--glob", "!.git" } }
                    or {}
                builtin.find_files(find_files_options)
            end, {})
            vim.keymap.set("n", "<c-space>r", builtin.live_grep, {})
            vim.keymap.set("n", "<c-space>f", builtin.buffers, {})
            vim.keymap.set("n", "<c-space>t", builtin.tags, {})
            vim.keymap.set("n", "<c-space>z", builtin.oldfiles, {})
            vim.keymap.set("n", "<c-space>\"", builtin.registers, {})
            vim.keymap.set("n", "<c-space>/", builtin.search_history, {})
            vim.keymap.set("n", "<c-space>g", builtin.git_files, {})
            vim.keymap.set("n", "<c-space>b", builtin.git_bcommits, {})
            vim.keymap.set("n", "<c-space>c", builtin.quickfix, {})
            vim.keymap.set("n", "<c-space>d", function()
                builtin.find_files({
                    find_command = {
                        "git", -- equivalent to the `dotfiles` alias
                        "--git-dir",
                        vim.env.HOME .. "/.dotfiles",
                        "--work-tree",
                        vim.env.HOME,
                        "ls-files",
                    },
                })
            end)
            vim.keymap.set("n", "<c-space>l", builtin.loclist, {})
            vim.keymap.set(
                { "n" },
                "<c-space>s",
                function() require("telescope.builtin").symbols({ sources = { "emoji", "kaomoji" } }) end,
                { silent = true }
            )
            telescope.setup({
                defaults = {
                    layout_strategy = "vertical",
                    layout_config = {
                        vertical = {
                            height = 0.95,
                            preview_cutoff = 40,
                            prompt_position = "bottom",
                            width = 0.95,
                        },
                    },
                },
            })
            require("telescope").load_extension("fzf")
        end,
    },

    {
        "williamboman/mason.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            require("mason").setup()
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "mason.nvim",
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "bashls",
                    "cssls",
                    "html",
                    "eslint",
                    "jdtls",
                    "jsonls",
                    "kotlin_language_server",
                    "marksman",
                    "lua_ls",
                    "omnisharp",
                    "pyright",
                    "ts_ls",
                    "vimls",
                    "yamlls",
                },
            })
        end,
    },

    {
        "nvimtools/none-ls.nvim",
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                on_attach = require("lsp-on-attach").on_attach_enable_format_on_write,
                sources = {
                    null_ls.builtins.diagnostics.cfn_lint,
                    null_ls.builtins.diagnostics.commitlint.with({
                        condition = function(utils)
                            return utils.root_has_file({ "commitlint.config.js" })
                        end
                    }),
                    null_ls.builtins.formatting.prettierd,
                }
            })
            require("null-ls").register(require("none-ls-shellcheck.diagnostics"))
            require("null-ls").register(require("none-ls-shellcheck.code_actions"))
        end,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "gbprod/none-ls-shellcheck.nvim",
        },
    },

    { "neovim/nvim-lspconfig" },

    {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup({
                icons = false,
            })
        end,
    },

    {
        "klen/nvim-config-local",
        config = function()
            require("config-local").setup({
                config_files = { ".vim/vimrc.lua", ".vim/vimrc" },
                hashfile = vim.fn.stdpath("data") .. "/config-local",
                autocommands_create = true,
                commands_create = true,
                silent = false,
                lookup_parents = false,
            })
        end,
    },

    {
        "folke/neodev.nvim",
        config = function()
            require("neodev").setup({
                nvim_cfg = true, -- index local nvim cfg
                override = function(root_dir, library)
                    local pathSeparator = package.config:sub(1, 1)
                    if string.find(root_dir, "nvim" .. pathSeparator .. "lua") then
                        library.enabled = true
                        library.plugins = true
                    end
                end,
            })
        end,
    },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    {
        "L3MON4D3/LuaSnip",
        config = function()
            local luasnip = require("luasnip")
            luasnip.setup({
                snip_env = {
                    choice_node = function(...) return luasnip.c(...) end,
                    dynamic_node = function(...) return luasnip.d(...) end,
                    function_node = function(...) return luasnip.f(...) end,
                    indent_snippet_node = function(...) return luasnip.indent_snippet_node(...) end,
                    insert_node = function(...) return luasnip.i(...) end,
                    repeat_node = function(...) return require("luasnip.extras").rep(...) end,
                    restore_node = function(...) return luasnip.r(...) end,
                    snippet = function(...) return luasnip.s(...) end,
                    snippet_node = function(...) return luasnip.sn(...) end,
                    text_node = function(...) return luasnip.t(...) end,
                },
            })

            require("luasnip.loaders.from_lua").lazy_load({
                paths = { "~/.config/nvim/lua/snippets" }
            })
        end,
    },
    { "saadparwaiz1/cmp_luasnip" },
    {
        "David-Kunz/cmp-npm",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("cmp-npm").setup({})
        end
    },
    {
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        dependencies = { { "nvim-lua/plenary.nvim" } },
        config = function()
            require("crates").setup({})
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        dependencies = { "onsails/lspkind.nvim" },
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
                            symbol_map = ({
                                Text = "文",
                                Method = "技",
                                Function = "関",
                                Constructor = "作",
                                Field = "有",
                                Variable = "変",
                                Class = "ｸﾗｽ",
                                Interface = "引",
                                Module = "組",
                                Property = "質",
                                Unit = "単",
                                Value = "値",
                                Enum = "列挙",
                                Keyword = "予",
                                Snippet = "切",
                                Color = "色",
                                File = "ﾌｧｪﾙ",
                                Reference = "指",
                                Folder = "結",
                                EnumMember = "列挙類",
                                Constant = "定",
                                Struct = "構造",
                                Event = "行",
                                Operator = "演算子",
                                TypeParameter = "型",
                            }),
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

            -- condition sets whether the server is setup for the local server
            local languageServers = {
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

            local on_attach = require("lsp-on-attach").on_attach_default
            for lsp, options in pairs(languageServers) do
                if options.condition == nil or options.condition then
                    options.capabilities = options.capabilities or capabilities
                    options.on_attach = options.on_attach or on_attach
                    lspconfig[lsp].setup(options)
                end
            end
        end,
    },

    {
        "mrcjkb/rustaceanvim",
        ft = { 'rust' },
        config = function()
            local on_attach = require("lsp-on-attach").on_attach_default
            vim.g.rustaceanvim = {
                server = {
                    on_attach = on_attach,
                    default_settings = {
                        ['rust-analyzer'] = {
                            cargo = {
                                allFeatures = true,
                            },
                            check = {
                                command = "clippy"
                            },
                        },
                    },
                },
            }
        end,
    },


    {
        "lambdalisue/suda.vim",
        init = function()
            vim.cmd([[
                command! -nargs=0 Sw w suda://%
            ]])
        end,
    },

    -- Appearances
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            local lualine = require("lualine")
            lualine.setup({
                options = {
                    icons_enabled = false,
                    theme = "dracula",
                    separator = { left = "", right = "" }
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff" },
                    lualine_c = { "filename" },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                }
            })
        end,
    },

    {
        "gcmt/taboo.vim",
        init = function()
            vim.g.taboo_tab_format = " %N [%f%m] "
        end,
    },

    {
        "navarasu/onedark.nvim",
        config = function()
            require("onedark").setup({
                style = "dark",
                code_style = {
                    comments = "none",
                },
                colors = {
                    bg0 = "#1d1f21"
                },
            })
            require("onedark").load()
        end,
    },
    {
        "brenoprata10/nvim-highlight-colors",
        config = function()
            require("nvim-highlight-colors").setup({
                render = "background",
            })
        end,
    },

    -- Languages
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                auto_install = true,
                ignore_install = {},
                ensure_installed = { "c", "lua", "vim", "vimdoc" },
                highlight = {
                    enable = true, -- false will disable the whole extension
                },
                indent = {
                    enable = true,
                },
                modules = {},
                sync_install = false,
                textobjects = {
                    select = {
                        enable = true,
                        include_surrounding_whitespace = true,
                        keymaps = {
                            ["ia"] = { query = "@parameter.inner" },
                            ["aa"] = { query = "@parameter.outer" },
                            ["if"] = { query = "@function.inner" },
                            ["af"] = { query = "@function.outer" },
                            ["ic"] = { query = "@class.inner" },
                            ["ac"] = { query = "@class.outer" },
                        },
                        lookahead = true,
                        selection_modes = {
                            ["@parameter.outer"] = "v",
                            ["@function.outer"] = "v",
                            ["@class.outer"] = "v",
                        },
                    },
                }
            })

            vim.cmd([[
                set foldmethod=expr
                set foldexpr=nvim_treesitter#foldexpr()
            ]])
        end,
    },

    { "mboughaba/i3config.vim" },
    { "ron-rs/ron.vim" },
    { "PProvost/vim-ps1" },
    {
        "lervag/vimtex",
        ft = { "tex" },
    },
    {
        "previm/previm",
        dependencies = { "tyru/open-browser.vim" },
        ft = { "markdown" },
        cmd = { "PrevimOpen" },
        init = function()
            vim.g.previm_enable_realtime = 0
            vim.g.previm_disable_vimproc = 1
        end,
    },
}
