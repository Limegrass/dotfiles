if $VIMCONFIG == '' " name is sensitive for coc-settings.json
    let $VIMCONFIG = expand('<sfile>:p:h')
endif
if empty(glob($VIMCONFIG.'/autoload/plug.vim'))
    silent !curl -fLo $VIMCONFIG/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin($VIMCONFIG.'/plugged')
Plug 'tpope/vim-surround'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'wellle/targets.vim'
Plug 'kana/vim-textobj-user'
Plug 'Julian/vim-textobj-variable-segment'
Plug 'andymass/vim-matchup'
Plug 'michaeljsmith/vim-indent-object'
Plug 'godlygeek/tabular'
Plug 'sjl/gundo.vim', {'on': ['GundoToggle', 'GundoShow']}
    let g:gundo_prefer_python3 = 1
Plug 'Valloric/ListToggle'
    let g:lt_location_list_toggle_map = '<SPACE>l'
    let g:lt_quickfix_list_toggle_map = '<SPACE>c'
Plug 'moll/vim-bbye'
    command! -bang -complete=buffer -nargs=? Bclose Bdelete<bang> <args>
    nnoremap <silent> ZD :Bdelete<CR>
Plug 'tpope/vim-commentary'
    augroup commentary
        autocmd!
        autocmd FileType sql setlocal commentstring=--\ %s
        autocmd FileType cs setlocal commentstring=//\ %s
    augroup END
    nnoremap <silent> <leader><Tab> :Commentary<CR>
    xnoremap <silent> <leader><Tab> :Commentary<CR>
Plug 'tpope/vim-dispatch'
Plug 'voldikss/vim-floaterm'
    nnoremap <space>t :FloatermToggle<CR>
    nnoremap <space>rs :FloatermSend<CR>
    xnoremap <space>rs :FloatermSend<CR>
    command! PythonRepl FloatermNew name=python_repl width=0.3 position=bottomright python
    augroup floaterm
        autocmd!
        autocmd FileType floaterm tnoremap <buffer> <C-C> <C-\><C-N>:FloatermToggle<CR>
    augroup END
    let g:floaterm_gitcommit = 'floaterm'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    let g:fzf_layout = { 'down' : '20%'}
    nnoremap <silent> <C-SPACE>  :FZF<CR>
    nnoremap <silent> g<C-SPACE> :Tags<CR>
    nnoremap <silent> z<C-SPACE> :Rg<CR>
    " Searches plugin folder with Rg
    command! -bang -nargs=* HelpgrepPlugin
                \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case "
                \                   .shellescape(<q-args>)." ".expand('$VIMCONFIG/plugged'),
                \                   1, {}, <bang>0)

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

if has('python3') && executable('python3') " python dependency
    Plug 'SirVer/ultisnips'
        let g:UltiSnipsExpandTrigger  = "<C-S>"
        let g:UltiSnipsJumpForwardTrigger  = "<C-J>"
        let g:UltiSnipsJumpBackwardTrigger = "<C-K>"
        let g:UltiSnipsRemoveSelectModeMappings = 0
        xnoremap <TAB> :call UltiSnips#SaveLastVisualSelection()<CR>gvs
endif

if executable('npm') && executable('node') " node dependency
    Plug 'neoclide/coc.nvim', { 'tag': '*' }
        command! CocInstallExtensions CocInstall
                    \ coc-dictionary coc-tag coc-omni coc-syntax coc-ultisnips
                    \ coc-json coc-vimtex coc-python coc-java coc-highlight coc-html coc-yank
                    \ coc-vimlsp coc-lists coc-git coc-rls coc-marketplace
        set updatetime=300 " Smaller updatetime for CursorHold & CursorHoldI
        set shortmess+=c " don't give |ins-completion-menu| messages.
        inoremap <silent> <expr> <c-space> coc#refresh() " completion refresh
        " errors
        nnoremap <silent> [c :call <SID>CocActionAsyncOrDefault('diagnosticPrevious', '[c')<CR>
        nnoremap <silent> ]c :call <SID>CocActionAsyncOrDefault('diagnosticNext', ']c')<CR>
        nnoremap <silent> gd :call <SID>CocActionAsyncOrDefault('jumpDefinition', 'gd')<CR>
        nnoremap <silent> gD :call <SID>CocActionAsyncOrDefault('jumpImplementation', 'gD')<CR>
        nnoremap <silent> K :call <SID>CallCocActionAsyncOrDefaultAndReturnNull('doHover', 'K')<CR>
        nmap <silent> <leader>gd <Plug>(coc-type-definition)
        nmap <silent> <leader>fr <Plug>(coc-references)
        function! s:CocActionAsyncOrDefault(coc_action, default_action)
            let Callback = { _, response ->
                        \ execute(response ? '' : 'normal! '.a:default_action) }
            call CocActionAsync(a:coc_action, Callback)
        endfunction
        function! s:CallCocActionAsyncOrDefaultAndReturnNull(coc_action, default_action)
            call <SID>CocActionAsyncOrDefault(a:coc_action, a:default_action)
            return '\<NUL>'
        endfunction
        nmap <silent> <leader>rn <Plug>(coc-rename)
        vmap <silent> <leader>=  <Plug>(coc-format-selected)
        nmap <silent> <leader>=  <Plug>(coc-format-selected)
        augroup coc
          autocmd!
          autocmd CursorHold * silent call CocActionAsync('highlight')
          autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
          autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
        augroup end
        " quickfix/code actions
        vmap <silent> <leader>aa <Plug>(coc-codeaction-selected)
        nmap <silent> <leader>aa <Plug>(coc-codeaction-selected)
        nmap <silent> <leader>ac <Plug>(coc-codeaction)
        nmap <silent> <leader>al <Plug>(coc-codelens-action)
        nmap <silent> <leader>qf <Plug>(coc-fix-current)
        command! -nargs=0 Format :call CocAction('format')
        command! -nargs=? Fold :call   CocAction('fold', <f-args>)
        xmap if <Plug>(coc-funcobj-i)
        xmap af <Plug>(coc-funcobj-a)
        omap if <Plug>(coc-funcobj-i)
        omap af <Plug>(coc-funcobj-a)
endif


Plug 'lambdalisue/suda.vim'
    if has('nvim')
        command! -nargs=0 Sw w suda://%
    endif
Plug 'francoiscabrol/ranger.vim'
    let g:ranger_map_keys = 0
    let g:ranger_choice_file = '/tmp/ranger_choice_file'

" Appearances
Plug 'bling/vim-airline'
    let g:airline_theme='deus'
Plug 'vim-airline/vim-airline-themes'
Plug 'gcmt/taboo.vim'
    let g:taboo_tab_format=' %N [%f%m] '
Plug 'flazz/vim-colorschemes'

" Specialized
Plug 'sheerun/vim-polyglot'
    let g:rust_recommended_style = 0 " don't want ts=8
    let g:polyglot_disabled = ['latex']
Plug 'OrangeT/vim-csharp' " Needed for cshtml
Plug 'lervag/vimtex', {'for': ['tex']}
Plug 'previm/previm', {'for': ['markdown'], 'on': ['PrevimOpen']}
    Plug 'tyru/open-browser.vim'
    let g:previm_enable_realtime = 0
    let g:previm_disable_vimproc = 1
call plug#end()
colorscheme angr
