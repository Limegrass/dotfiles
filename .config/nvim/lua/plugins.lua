local packer_install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(packer_install_path)) > 0 then
    packer_bootstrap = vim.fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        packer_install_path
    })
end

return require("packer").startup(function(use)
    use({ "wbthomason/packer.nvim" })

    use({ "chrisbra/unicode.vim" })
    use({
        "junegunn/vim-peekaboo",
        config = function()
            vim.g.peekaboo_delay = 400
        end,
    })

    use({ "tpope/vim-fugitive" })
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

    use({
        "junegunn/fzf.vim",
        requires = { "junegunn/fzf" },
        cmd = { "FZF", "History", "Rg", "Buffers", "Tags" },
        setup = function()
            vim.g.fzf_layout = { down = "50%" }
            vim.cmd([[
                nnoremap <silent> <C-SPACE>  :FZF<CR>
                nnoremap <silent> f<C-SPACE> :Buffers<CR>
                nnoremap <silent> t<C-SPACE> :Tags<CR>
                nnoremap <silent> r<C-SPACE> :Rg<CR>
                nnoremap <silent> z<C-SPACE> :History<CR>
            ]])
        end,
    })

    use({
        "neoclide/coc.nvim",
        branch = "release",
        config = function()
            vim.g.coc_global_extensions = {
                "coc-css",
                "coc-diagnostic",
                "coc-dictionary",
                "coc-emoji",
                "coc-git",
                "coc-highlight",
                "coc-html",
                "coc-json",
                "coc-lists",
                "coc-marketplace",
                "coc-omni",
                "coc-snippets",
                "coc-syntax",
                "coc-tag",
                "coc-vimlsp",
                "coc-yank"
            }
            vim.cmd([[
                command! CocInstallJavaScript CocInstall coc-tsserver coc-prettier coc-eslint
                command! CocInstallRust CocInstall coc-rust-analyzer
                command! CocInstallJava CocInstall coc-java
                command! CocInstallPython CocInstall coc-pyright
                command! CocInstallLatex CocInstall coc-vimtex

                set updatetime=300 " Smaller updatetime for CursorHold & CursorHoldI
                set shortmess+=c " don't give |ins-completion-menu| messages.
                inoremap <silent> <expr> <c-space> coc#refresh() " completion refresh
                " errors
                nnoremap <silent> [c :call CocActionAsyncOrDefault("diagnosticPrevious", "[c")<CR>
                nnoremap <silent> ]c :call CocActionAsyncOrDefault("diagnosticNext", "]c")<CR>
                nnoremap <silent> gd :call CocActionAsyncOrDefault("jumpDefinition", "gd")<CR>
                nnoremap <silent> gD :call CocActionAsyncOrDefault("jumpImplementation", "gD")<CR>
                nnoremap <silent> K :call CallCocActionAsyncOrDefaultAndReturnNull("doHover", "K")<CR>
                nmap <silent> <leader>gd <Plug>(coc-type-definition)
                nmap <silent> <leader>fr <Plug>(coc-references)
                function! CocActionAsyncOrDefault(coc_action, default_action)
                let Callback = { _, response ->
                \ execute(response ? "" : "normal! ".a:default_action) }
                call CocActionAsync(a:coc_action, Callback)
                endfunction
                function! CallCocActionAsyncOrDefaultAndReturnNull(coc_action, default_action)
                call CocActionAsyncOrDefault(a:coc_action, a:default_action)
                return '\<NUL>'
                endfunction
                nmap <silent> <leader>rn <Plug>(coc-rename)
                vmap <silent> <leader>=  <Plug>(coc-format-selected)
                nmap <silent> <leader>=  <Plug>(coc-format-selected)
                augroup coc
                autocmd!
                autocmd CursorHold * silent call CocActionAsync("highlight")
                autocmd FileType typescript,json setl formatexpr=CocAction("formatSelected")
                autocmd User CocJumpPlaceholder call CocActionAsync("showSignatureHelp")
                augroup end
                " quickfix/code actions
                xmap <silent> <leader>aa <Plug>(coc-codeaction-selected)
                nmap <silent> <leader>aa v<Plug>(coc-codeaction-selected)
                nmap <silent> <leader>ac <Plug>(coc-codeaction)
                nmap <silent> <leader>al <Plug>(coc-codelens-action)
                nmap <silent> <leader>qf <Plug>(coc-fix-current)
                command! -nargs=0 Format :call CocAction("format")
                command! -nargs=? Fold :call   CocAction("fold", <f-args>)
                xmap if <Plug>(coc-funcobj-i)
                xmap af <Plug>(coc-funcobj-a)
                omap if <Plug>(coc-funcobj-i)
                omap af <Plug>(coc-funcobj-a)
                nnoremap <silent> g<C-SPACE> :<C-u>CocList -I symbols<cr>
                nnoremap <silent> <space>rr :silent CocRestart<cr>
                nnoremap <silent> <space>el :CocList diagnostics<cr>
                nnoremap <silent> <space>en :CocNext<cr>
                nnoremap <silent> <space>ep :CocPrev<cr>
                nnoremap <silent> <space>cc  :CocCommand<cr>
            ]])
        end,
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
                    separator = { left = "", right = ""}
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
            vim.g.taboo_tab_format=" %N [%f%m] "
        end
    })

    use({
        "w0ng/vim-hybrid",
        config = function()
            vim.cmd([[
                colorscheme hybrid
                highlight EndOfBuffer guifg=bg
                highlight MatchParen guifg=NONE
            ]])
        end
    })

    -- Languages
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = "all",
                ignore_install = {},
                highlight = {
                    enable = true, -- false will disable the whole extension
                },
                indent = {
                    enable = true,
                },
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

    if packer_bootstrap then
        require("packer").sync()
    end
end)
