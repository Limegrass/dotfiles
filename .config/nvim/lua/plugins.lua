return {
    { "NMAC427/guess-indent.nvim" }, -- automatic tabstop/shiftwidth
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
            vim.keymap.set("n", "<c-space><BS>", builtin.resume, {})
            vim.keymap.set("n", "<c-space>d", function()
                builtin.find_files({
                    cwd = vim.env.HOME,
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
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
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
    {
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        dependencies = { { "nvim-lua/plenary.nvim" } },
        config = function()
            require("crates").setup({})
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
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            cmdline = {
                enabled = false,
                view = "cmdline",
                opts = {},
                format = {
                    cmdline = { pattern = "^:", icon = ">", lang = "vim" },
                    search_down = { kind = "search", pattern = "^/", icon = "🔍⌄", lang = "regex" },
                    search_up = { kind = "search", pattern = "^%?", icon = "🔍⌃", lang = "regex" },
                    filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
                    lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "☾", lang = "lua" },
                    help = { pattern = "^:%s*he?l?p?%s+", icon = "?" },
                    input = { view = "cmdline_input", icon = "i>" },
                },
            },
            messages = {
                enabled = false,
                view = "notify",
                view_error = "notify",
                view_warn = "notify",
                view_history = "messages",
                view_search = "virtualtext",
            },
            popupmenu = {
                enabled = true,
                backend = "nui",
                kind_icons = {},
            },
            redirect = {
                view = "popup",
                filter = { event = "msg_show" },
            },
            commands = {
                history = {
                    view = "split",
                    opts = { enter = true, format = "details" },
                    filter = {
                        any = {
                            { event = "notify" },
                            { error = true },
                            { warning = true },
                            { event = "msg_show", kind = { "" } },
                            { event = "lsp",      kind = "message" },
                        },
                    },
                },
                last = {
                    view = "popup",
                    opts = { enter = true, format = "details" },
                    filter = {
                        any = {
                            { event = "notify" },
                            { error = true },
                            { warning = true },
                            { event = "msg_show", kind = { "" } },
                            { event = "lsp",      kind = "message" },
                        },
                    },
                    filter_opts = { count = 1 },
                },
                errors = {
                    view = "popup",
                    opts = { enter = true, format = "details" },
                    filter = { error = true },
                    filter_opts = { reverse = true },
                },
                all = {
                    view = "split",
                    opts = { enter = true, format = "details" },
                    filter = {},
                },
            },
            notify = {
                enabled = false,
                view = "notify",
            },
            lsp = {
                progress = {
                    enabled = true,
                    format = "lsp_progress",
                    format_done = "lsp_progress_done",
                    throttle = 1000 / 30,
                    view = "mini",
                },
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
                    ["vim.lsp.util.stylize_markdown"] = false,
                    ["cmp.entry.get_documentation"] = false,
                },
                hover = {
                    enabled = true,
                    silent = false,
                    view = nil,
                    opts = {},
                },
                signature = {
                    enabled = true,
                    auto_open = {
                        enabled = true,
                        trigger = true,
                        luasnip = true,
                        throttle = 50,
                    },
                    view = nil,
                    opts = {},
                },
                message = {
                    enabled = true,
                    view = "notify",
                    opts = {},
                },
                documentation = {
                    view = "hover",
                    opts = {
                        lang = "markdown",
                        replace = true,
                        render = "plain",
                        format = { "{message}" },
                        win_options = { concealcursor = "n", conceallevel = 3 },
                    },
                },
            },
            markdown = {
                hover = {
                    ["|(%S-)|"] = vim.cmd.help,
                    ["%[.-%]%((%S-)%)"] = require("noice.util").open,
                },
                highlights = {
                    ["|%S-|"] = "@text.reference",
                    ["@%S+"] = "@parameter",
                    ["^%s*(Parameters:)"] = "@text.title",
                    ["^%s*(Return:)"] = "@text.title",
                    ["^%s*(See also:)"] = "@text.title",
                    ["{%S-}"] = "@parameter",
                },
            },
            health = {
                checker = true,
            },
            presets = {
                bottom_search = false,
                command_palette = false,
                long_message_to_split = false,
                inc_rename = false,
                lsp_doc_border = false,
            },
            throttle = 1000 / 30,
            views = {},
            routes = {},
            status = {},
            format = {
                level = {
                    icons = {
                        error = "✖",
                        warn = "▼",
                        info = "●",
                    },
                },
            },
            inc_rename = {
                cmdline = {
                    format = {
                        IncRename = { icon = "⟳" },
                    },
                },
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        }
    },

    {
        "navarasu/onedark.nvim",
        lazy = false,
        priority = 1000,
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
