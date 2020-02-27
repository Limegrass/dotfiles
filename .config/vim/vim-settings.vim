"   Sections:
"       BASIC_SETTINGS
"       AUTOCOMMANDS
"       VARIABLE_DEFINITIONS
" ==============================================================================
" BASIC_SETTINGS
" ==============================================================================
if has('nvim')
    set inccommand=split
endif

filetype plugin on
set lazyredraw
set ruler
set incsearch
set ignorecase
set smartcase
set number
set nowrap
set listchars=tab:▸\ ,trail:·,precedes:←,extends:→,nbsp:·
set backspace=indent,eol,start
set scrolljump=3
set list
set selection=inclusive
set undofile
set autoread
set history=100
set cursorline
set hidden
set diffopt+=vertical,iwhite,hiddenoff
set fileformats=unix,dos
set fileignorecase
set virtualedit=all
set nostartofline
set spelllang=en
set mouse=nicr
set splitright
set splitbelow
set foldmethod=indent
set foldlevel=99
set completeopt=noinsert,menuone,noselect
runtime macros/matchit.vim
let g:omni_sql_no_default_maps = 1
" INDENT SETTINGS
set expandtab
set smartindent
set autoindent
set tabstop=4
set shiftwidth=4
set softtabstop=-1
set formatoptions^=j " default in nvim but not vim
" Character limit highlight
call matchadd('ColorColumn', '\%81v.', 100)
" Prevent starting in Hiragana
set iminsert=0
set imsearch=-1

" undo/swap/temp in designated folders. nvim autocreates but vim does not.
set undodir=$VIMCONFIG/undo
if !isdirectory($VIMCONFIG.'/undo')
    call mkdir($VIMCONFIG.'/undo')
endif
set backupdir=$VIMCONFIG/backup
if !isdirectory($VIMCONFIG.'/backup')
    call mkdir($VIMCONFIG.'/backup')
endif

set noswapfile " swap prevents opening the same file in diff instances.
set directory=$VIMCONFIG/swap " keep files separate if turned on.
if !isdirectory($VIMCONFIG.'/swap')
    call mkdir($VIMCONFIG.'/swap')
endif

set termguicolors
set background=dark

set wildmenu
set wildmode=longest:full
set wildignorecase                              " Ignore case
set wildignore+=*.zip,*.tar,*.tar*,*.rar        " Ignore archive files
set wildignore+=*.png,*.jpg,*.jpeg,*.gif        " Ignore images
set wildignore+=*.pdf
set wildignore+=*.DS_Store
set wildignore+=*yarn.lock*
set wildignore+=*.gem,*.obj,*.out,*.swp
set wildignore+=.git,.hg,*/.git/*,**/.git/**

" ==============================================================================
" AUTOCOMMANDS
" ==============================================================================
" QuickFix window on vimgrep
if has('autocmd')
    augroup QuickFix
        autocmd!
        autocmd CmdwinEnter * nnoremap <CR> <CR>
        autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
    augroup END

    " Autocompletion for HTML tags
    augroup Html
        autocmd!
        autocmd Filetype html,xml,markdown inoremap <buffer> </ </<C-X><C-O>
    augroup END

    augroup PrevimSettings
        autocmd!
        autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
    augroup END

    augroup CSharp
        autocmd!
        autocmd BufReadPost *.{cs} silent call TFCheckout()
    augroup END
endif

" ==============================================================================
" VARIABLE_DEFINITIONS
" ==============================================================================
let g:guid_regex = '[a-zA-Z0-9]\{8,8}-[a-zA-Z0-9]\{4,4}-'
            \ .'[a-zA-Z0-9]\{4,4}-[a-zA-Z0-9]\{4,4}-[a-zA-Z0-9]\{12,12}'
