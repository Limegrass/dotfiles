if empty(glob($VIMCONFIG.'/autoload/plug.vim'))
    silent !curl -fLo $VIMCONFIG/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin($VIMCONFIG.'/plugged')

" Core
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
    augroup commentary
        autocmd!
        autocmd FileType sql setlocal commentstring=--\ %s
        autocmd FileType cs setlocal commentstring=//\ %s
    augroup END
    nnoremap <silent> <leader><Tab> :Commentary<CR>
    xnoremap <silent> <leader><Tab> :Commentary<CR>

Plug 'tpope/vim-unimpaired'
Plug 'wellle/targets.vim'
Plug 'andymass/vim-matchup'
Plug 'michaeljsmith/vim-indent-object'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    let g:fzf_layout = { 'down' : '20%'}
    nnoremap <silent> <C-SPACE>  :FZF<CR>
    nnoremap <silent> g<C-SPACE> :Tags<CR>
    nnoremap <silent> z<C-SPACE> :Rg<CR>
Plug 'haya14busa/incsearch.vim'
    Plug 'haya14busa/incsearch-fuzzy.vim'
    let g:incsearch#auto_nohlsearch = 1
    nmap n  <Plug>(incsearch-nohl-n)
    nmap N  <Plug>(incsearch-nohl-N)
    nmap *  <Plug>(incsearch-nohl-*)
    nmap #  <Plug>(incsearch-nohl-#)
    nmap g* <Plug>(incsearch-nohl-g*)
    nmap g# <Plug>(incsearch-nohl-g#)
    nmap /  <Plug>(incsearch-forward)
    nmap ?  <Plug>(incsearch-backward)
    nmap g/ <Plug>(incsearch-stay)
    nmap z/ <Plug>(incsearch-fuzzy-/)
    nmap z? <Plug>(incsearch-fuzzy-?)
    nmap zg/ <Plug>(incsearch-fuzzy-stay)
    nmap <leader>/ <Plug>(incsearch-fuzzyspell-/)
    nmap <leader>? <Plug>(incsearch-fuzzyspell-?)
    nmap <leader>g/ <Plug>(incsearch-fuzzyspell-stay)
    augroup incsearch-keymap
        autocmd!
        autocmd VimEnter * call s:incsearch_keymap()
    augroup END
    function! s:incsearch_keymap()
        IncSearchNoreMap <C-S-n> <Over>(buffer-complete)
        IncSearchNoreMap <C-S-p> <Over>(buffer-complete-prev)
        IncSearchNoreMap <M-/> <CR>gv<C-]>
    endfunction
Plug 'qpkorr/vim-bufkill'
    let g:BufKillCreateMappings = 0
if has('python3') && executable('python3') " python dependency
    Plug 'SirVer/ultisnips'
        let g:UltiSnipsExpandTrigger  = "<NUL>"
        let g:UltiSnipsJumpForwardTrigger  = "<C-J>"
        let g:UltiSnipsJumpBackwardTrigger = "<C-K>"
        let g:UltiSnipsRemoveSelectModeMappings = 0
        xnoremap <TAB> :call UltiSnips#SaveLastVisualSelection()<CR>gvs
endif
if executable('npm') && executable('node') " node dependency
    Plug 'neoclide/coc.nvim', { 'tag': '*' }
        " sets directory path for coc-settings.json to the same directory as this file
        let $VIMCONFIG = expand('<sfile>:p:h')
        command! CocInstallExtensions CocInstall
                    \ coc-dictionary coc-tag coc-omni coc-syntax coc-ultisnips
                    \ coc-json coc-vimtex coc-python coc-java coc-highlight coc-html coc-yank
                    \ coc-vimlsp coc-lists coc-git coc-rls coc-marketplace

        set updatetime=300 " Smaller updatetime for CursorHold & CursorHoldI
        set shortmess+=c " don't give |ins-completion-menu| messages.

        inoremap <silent> <expr> <c-space> coc#refresh() " Use <c-space> for trigger completion.

        " Use `[c` and `]c` for navigate diagnostics
        nnoremap <silent> [c :call <SID>CocActionAsyncOrDefault('diagnosticPrevious', '[c')<CR>
        nnoremap <silent> ]c :call <SID>CocActionAsyncOrDefault('diagnosticNext', ']c')<CR>

        " Remap keys for gotos
        nnoremap <silent> gd :call <SID>CocActionAsyncOrDefault('jumpDefinition', 'gd')<CR>
        nnoremap <silent> gD :call <SID>CocActionAsyncOrDefault('jumpImplementation', 'gD')<CR>
        nmap <silent> <leader>gd <Plug>(coc-type-definition)
        nmap <silent> <leader>fr <Plug>(coc-references)
        function! s:CocActionAsyncOrDefault(coc_action, default_action)
            let Callback = { _, response ->
                        \ execute(response ? '' : 'normal! '.a:default_action) }
            call CocActionAsync(a:coc_action, Callback)
        endfunction

        nnoremap <silent> K :call <SID>CallCocActionAsyncOrDefaultAndReturnNull('doHover', 'K')<CR>
        function! s:CallCocActionAsyncOrDefaultAndReturnNull(coc_action, default_action)
            call <SID>CocActionAsyncOrDefault(a:coc_action, a:default_action)
            return '\<NUL>'
        endfunction

        " Highlight symbol under cursor on CursorHold
        autocmd CursorHold * silent call CocActionAsync('highlight')

        " Remap for rename current word
        nmap <silent> <leader>rn <Plug>(coc-rename)

        " Remap for format selected region
        vmap <silent> <leader>=  <Plug>(coc-format-selected)
        nmap <silent> <leader>=  <Plug>(coc-format-selected)

        augroup coc
          autocmd!
          " Setup formatexpr specified filetype(s).
          autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
          " Update signature help on jump placeholder
          autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
        augroup end

        " Remap for do codeAction of selected region,
        vmap <silent> <leader>a  <Plug>(coc-codeaction-selected)
        nmap <silent> <leader>a  <Plug>(coc-codeaction-selected)

        " Remap for do codeAction of current line
        nmap <silent> <leader>ac <Plug>(coc-codeaction)
        nmap <silent> <leader>cl <Plug>(coc-codelens-action)

        " Fix autofix problem of current line
        nmap <silent> <leader>qf <Plug>(coc-fix-current)

        " Use `:Format` for format current buffer
        command! -nargs=0 Format :call CocAction('format')

        " Use `:Fold` for fold current buffer
        command! -nargs=? Fold :call   CocAction('fold', <f-args>)

        xmap if <Plug>(coc-funcobj-i)
        xmap af <Plug>(coc-funcobj-a)
        omap if <Plug>(coc-funcobj-i)
        omap af <Plug>(coc-funcobj-a)
endif
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-abolish'
Plug 'sheerun/vim-polyglot'
    let g:rust_recommended_style = 0 " don't want ts=8
Plug 'lambdalisue/suda.vim'
    if has('nvim')
        command! -nargs=0 SW w suda://%
    endif
Plug 'tpope/vim-dispatch'

Plug 'francoiscabrol/ranger.vim'
    command! -bang Bclose BD! " BD from vim-bufkill. working around rbgrouleff/bclose.vim
    let g:ranger_map_keys = 0
    let g:ranger_choice_file = '/tmp/ranger_choice_file'

" Appearances
Plug 'flazz/vim-colorschemes'
Plug 'aonemd/kuroi.vim'
Plug 'bling/vim-airline'
    let g:airline_theme='deus'
Plug 'vim-airline/vim-airline-themes'
Plug 'nathanaelkane/vim-indent-guides', {'on': ['IndentGuidesEnable', 'IndentGuidesToggle']}
    let g:indent_guides_enable_on_vim_startup = 0
Plug 'gcmt/taboo.vim'
    let g:taboo_tab_format=' %N [%f%m] '
Plug 'godlygeek/tabular'

" Rarely Used
Plug 'kshenoy/vim-signature'
    let g:SignatureEnabledAtStartup = 0
Plug 'sjl/gundo.vim', {'on': ['GundoToggle', 'GundoShow']}
    let g:gundo_prefer_python3 = 1

" Specialized
Plug 'OrangeT/vim-csharp' " Needed for cshtml
Plug 'lervag/vimtex', {'for': ['tex']}
    let g:vimtex_view_general_viewer  = 'SumatraPDF'
    let g:vimtex_view_general_options =
                \'-reuse-instance -forward-search @tex @line @pdf'
    let g:vimtex_view_general_options_latexmk = '-reuse-instance'
Plug 'previm/previm', {'for': ['markdown'], 'on': ['PrevimOpen']}
    Plug 'tyru/open-browser.vim'
    let g:previm_enable_realtime = 0
    let g:previm_disable_vimproc = 1

call plug#end()

colorscheme kuroi " alt: corporation, hybrid, zenburn. must go after plugins.
