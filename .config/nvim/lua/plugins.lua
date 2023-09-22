local packer_install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(packer_install_path)) > 0 then
    PACKER_BOOTSTRAP = vim.fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        packer_install_path
    })
end

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
                vim.lsp.buf.format({
                    bufnr = bufnr,
                    timeout_ms = 5000,
                    filter = FORMAT_FILTER
                })
            end,
        })
    end
end

return require("packer").startup(function(use)
    use({ "wbthomason/packer.nvim" })

    use({ "tpope/vim-fugitive" })
    use({
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                current_line_blame = true,
                current_line_blame_opts = {
                    delay = 500,
                },
            })
        end
    })
    use({ "rhysd/git-messenger.vim" })
    use({ "tpope/vim-surround" })
    use({ "tpope/vim-abolish" })
    use({ "tpope/vim-repeat" })
    use({ "tpope/vim-unimpaired" })
    use({ "wellle/targets.vim" })
    use({ "kana/vim-textobj-user" })
    use({
        "Julian/vim-textobj-variable-segment",
        branch = "main"
    })
    use({
        "andymass/vim-matchup",
        event = "VimEnter",
    })
    use({ "michaeljsmith/vim-indent-object" })
    use({ "godlygeek/tabular" })

    use({
        "sjl/gundo.vim",
        cmd = { "GundoToggle", "GundoShow" },
        config = function()
            vim.g.gundo_prefer_python3 = 1
        end
    })

    use({
        "moll/vim-bbye",
        config = function()
            vim.cmd([[
                command! -bang -complete=buffer -nargs=? Bclose Bdelete<bang> <args>
                nnoremap <silent> ZD :Bdelete<CR>
            ]])
        end
    })

    use({
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
        end
    })

    use({
        "tpope/vim-dispatch",
        opt = true,
        cmd = { "Dispatch", "Make", "Focus", "Start" },
    })

    use({ "roxma/vim-tmux-clipboard" })
    use({
        "voldikss/vim-floaterm",
        cmd = { "FloatermToggle" },
        setup = function()
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
    })

    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
    use({ "nvim-telescope/telescope-symbols.nvim" })
    use({
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        requires = { { "nvim-lua/plenary.nvim" } },
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<c-space>", function()
                local is_rg_available = vim.fn.executable("rg") == 1
                local find_files_options = is_rg_available
                    and { find_command = { "rg", "--files", "--hidden", "--glob", "!.git" } }
                    or {}
                builtin.find_files(find_files_options)
            end, {})
            vim.keymap.set("n", "r<c-space>", builtin.live_grep, {})
            vim.keymap.set("n", "f<c-space>", builtin.buffers, {})
            vim.keymap.set("n", "t<c-space>", builtin.tags, {})
            vim.keymap.set("n", "z<c-space>", builtin.oldfiles, {})
            vim.keymap.set("n", "\"<c-space>", builtin.registers, {})
            vim.keymap.set("n", "g<c-space>", builtin.git_files, {})
            vim.keymap.set("n", "gc<c-space>", builtin.git_bcommits, {})
            require("telescope").load_extension("fzf")
        end
    })

    use({
        "williamboman/mason.nvim",
        requires = { "neovim/nvim-lspconfig" },
        config = function()
            require("mason").setup()
        end
    })

    use({
        "williamboman/mason-lspconfig.nvim",
        requires = { "williamboman/mason.nvim" },
        after = { "mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                automatic_installation = true,
                ensure_installed = {
                    "bashls",
                    "cssls",
                    "html",
                    "jdtls",
                    "jsonls",
                    "kotlin_language_server",
                    "lua_ls",
                    "omnisharp",
                    "pyright",
                    "rust_analyzer",
                    "tsserver",
                    "vimls",
                    "yamlls",
                },
            })
        end
    })

    use({
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                on_attach = ON_ATTACH_ENABLE_FORMAT_ON_WRITE,
                sources = {
                    null_ls.builtins.code_actions.eslint,
                    null_ls.builtins.code_actions.shellcheck,
                    null_ls.builtins.diagnostics.cfn_lint,
                    null_ls.builtins.diagnostics.commitlint.with({
                        condition = function(utils)
                            return utils.root_has_file({ "commitlint.config.js" })
                        end
                    }),
                    null_ls.builtins.diagnostics.eslint,
                    null_ls.builtins.diagnostics.shellcheck,
                    null_ls.builtins.formatting.prettier,
                }
            })
        end,
        requires = { "nvim-lua/plenary.nvim" },
    })

    use({ "neovim/nvim-lspconfig" })

    use({
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup({
                icons = false
            })
        end
    })

    use({
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
        end
    })

    use({
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
    })
    use({ "hrsh7th/cmp-nvim-lsp" })
    use({ "hrsh7th/cmp-buffer" })
    use({ "hrsh7th/cmp-path" })
    use({ "hrsh7th/cmp-cmdline" })
    use({
        "L3MON4D3/LuaSnip",
        config = function()
            local luasnip = require("luasnip")
            luasnip.setup({
                snip_env = {
                    choice_node = function(...) return luasnip.c(...) end,
                    dynamic_node = function(...) return luasnip.d(...) end,
                    function_node = function(...) return luasnip.f(...) end,
                    indent_snippet_node = function(...) return luasnip.is(...) end,
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
        end
    })
    use({ "saadparwaiz1/cmp_luasnip" })
    use({
        "David-Kunz/cmp-npm",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("cmp-npm").setup({})
        end
    })
    use({
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        requires = { { "nvim-lua/plenary.nvim" } },
        config = function()
            require("crates").setup()
        end,
    })

    use({
        "hrsh7th/nvim-cmp",
        requires = { "onsails/lspkind.nvim" },
        config = function()
            local cmp = require("cmp")
            local lspconfig = require("lspconfig")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            cmp.setup({
                formatting = {
                    format = lspkind.cmp_format({
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
                    }),
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
                    { name = "buffer" },
                })
            })

            local cmdlineMapping = cmp.mapping.preset.cmdline({
                ["<C-y>"] = {
                    c = function(fallback)
                        if cmp.visible() then
                            cmp.confirm({ select = true })
                        else
                            fallback()
                        end
                    end,
                },
            })

            -- make completion show up again after confirmation in cmdline
            cmp.event:on("confirm_done", function(event)
                if event.entry.source.name == "cmdline" then
                    cmp.complete({})
                end
            end)

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
                    { name = "cmdline" }
                })
            })

            local opts = { noremap = true, silent = true }
            vim.keymap.set("n", "[k", vim.diagnostic.goto_prev, opts)
            vim.keymap.set("n", "]k", vim.diagnostic.goto_next, opts)
            vim.keymap.set("n", "<space>k", vim.diagnostic.open_float, opts)
            vim.keymap.set("n", "<space>K", vim.diagnostic.setloclist, opts)

            local on_attach_set_lsp_binds = function(client, bufnr)
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
                        filter = FORMAT_FILTER
                    })
                end, bufopts)

                vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
                vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr(#{timeout_ms:250})")
            end

            local on_attach_default = function(client, bufnr)
                on_attach_set_lsp_binds(client, bufnr)
                ON_ATTACH_ENABLE_FORMAT_ON_WRITE(client, bufnr)
            end

            local capabilities = require("cmp_nvim_lsp").default_capabilities(
                vim.lsp.protocol.make_client_capabilities()
            )

            -- condition sets whether the server is setup for the local server
            local languageServers = {
                bashls = {},
                cssls = {},
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
                omnisharp = {},
                powershell_es = {
                    condition = vim.fn.executable("pwsh") == 1
                },
                pyright = {},
                rust_analyzer = {
                    settings = {
                        ["rust-analyzer"] = {
                            cargo = {
                                allFeatures = true,
                            },
                            check = {
                                command = "clippy"
                            },
                        },
                    },
                },
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" }
                            },
                            workspace = {
                                library = {
                                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
                                }
                            },
                        },
                    },
                },
                tsserver = {},
                vimls = {},
                yamlls = {
                    settings = {
                        yaml = {
                            schemas = require("ls.yamlls.schemas"),
                        }
                    }
                }
            }

            for lsp, options in pairs(languageServers) do
                if options.condition == nil or options.condition then
                    options.capabilities = options.capabilities or capabilities
                    options.on_attach = options.on_attach or on_attach_default
                    lspconfig[lsp].setup(options)
                end
            end
        end
    })

    use({
        "lambdalisue/suda.vim",
        setup = function()
            vim.cmd([[
                command! -nargs=0 Sw w suda://%
            ]])
        end,
    })

    -- Appearances
    use({
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
        config = function()
            local lualine = require("lualine")
            lualine.setup({
                options = {
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
        end
    })

    use({
        "gcmt/taboo.vim",
        setup = function()
            vim.g.taboo_tab_format = " %N [%f%m] "
        end
    })

    use({
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
        end
    })

    -- Languages
    use({ "nvim-treesitter/nvim-treesitter-textobjects" })
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                auto_install = true,
                ignore_install = {},
                highlight = {
                    enable = true, -- false will disable the whole extension
                },
                indent = {
                    enable = true,
                },
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
        end
    })

    use({ "mboughaba/i3config.vim" })
    use({ "ron-rs/ron.vim" })
    use({ "PProvost/vim-ps1" })
    use({
        "lervag/vimtex",
        ft = { "tex" },
    })
    use({
        "previm/previm",
        requires = { "tyru/open-browser.vim" },
        ft = { "markdown" },
        cmd = { "PrevimOpen" },
        setup = function()
            vim.g.previm_enable_realtime = 0
            vim.g.previm_disable_vimproc = 1
        end,
    })

    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
