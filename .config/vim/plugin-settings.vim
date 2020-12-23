if $VIMCONFIG == '' " name is sensitive for coc-settings.json
    let $VIMCONFIG = expand('<sfile>:p:h')
endif
if empty(glob($VIMCONFIG.'/autoload/plug.vim'))
    silent !curl -fLo $VIMCONFIG/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin($VIMCONFIG.'/plugged')
Plug 'tpope/vim-fugitive'
Plug 'rhysd/git-messenger.vim'
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
Plug 'roxma/vim-tmux-clipboard'
Plug 'voldikss/vim-floaterm'
    nnoremap <silent> <space>t :FloatermToggle<CR>
    nnoremap <silent> <space>rs :FloatermSend<CR>
    xnoremap <silent> <space>rs :FloatermSend<CR>
    command! PythonRepl FloatermNew name=python_repl width=0.3 position=bottomright python
    augroup floaterm
        autocmd!
        autocmd FileType floaterm tnoremap <silent> <buffer> <C-J> <C-\><C-N>:FloatermToggle<CR>
    augroup END

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    let g:fzf_layout = { 'down' : '20%'}
    nnoremap <silent> <C-SPACE>  :FZF<CR>
    nnoremap <silent> f<C-SPACE>  :Buffers<CR>
    nnoremap <silent> t<C-SPACE> :Tags<CR>
    nnoremap <silent> r<C-SPACE> :Rg<CR>
    nnoremap <silent> z<C-SPACE> :History<CR>
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

if executable('npm') && executable('node') " node dependency
    Plug 'neoclide/coc.nvim', { 'branch': 'release' }
        let g:coc_global_extensions=[
                 \ 'coc-dictionary', 'coc-tag', 'coc-omni', 'coc-syntax', 'coc-snippets',
                 \ 'coc-highlight', 'coc-yank', 'coc-vimlsp', 'coc-lists', 'coc-git',
                 \ 'coc-html', 'coc-json', 'coc-marketplace' ]
        command! CocInstallJavaScript CocInstall coc-tsserver coc-prettier coc-eslint
        command! CocInstallRust CocInstall coc-rust-analyzer
        command! CocInstallJava CocInstall coc-java
        command! CocInstallPython CocInstall coc-python
        command! CocInstallLatex CocInstall coc-vimtex

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
        xmap <silent> <leader>aa <Plug>(coc-codeaction-selected)
        nmap <silent> <leader>aa v<Plug>(coc-codeaction-selected)
        nmap <silent> <leader>ac <Plug>(coc-codeaction)
        nmap <silent> <leader>al <Plug>(coc-codelens-action)
        nmap <silent> <leader>qf <Plug>(coc-fix-current)
        command! -nargs=0 Format :call CocAction('format')
        command! -nargs=? Fold :call   CocAction('fold', <f-args>)
        xmap if <Plug>(coc-funcobj-i)
        xmap af <Plug>(coc-funcobj-a)
        omap if <Plug>(coc-funcobj-i)
        omap af <Plug>(coc-funcobj-a)
        nnoremap <silent> g<C-SPACE> :<C-u>CocList -I symbols<cr>
        nnoremap <silent> <space>rr :silent CocRestart<cr>
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
Plug 'w0ng/vim-hybrid'

" Specialized
" TODO: Figure out a solution for cloning just https://trac.nginx.org/nginx/browser/nginx/contrib/vim
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'mboughaba/i3config.vim'
Plug 'udalov/kotlin-vim'
Plug 'cespare/vim-toml'
Plug 'ron-rs/ron.vim'
Plug 'PProvost/vim-ps1'
Plug 'OrangeT/vim-csharp' " Needed for cshtml
Plug 'lervag/vimtex', {'for': ['tex']}
Plug 'previm/previm', {'for': ['markdown'], 'on': ['PrevimOpen']}
    Plug 'tyru/open-browser.vim'
    let g:previm_enable_realtime = 0
    let g:previm_disable_vimproc = 1

call plug#end()
colorscheme hybrid
highlight EndOfBuffer guifg=bg
highlight MatchParen guifg=NONE
