if $VIMLOCAL == '' " set config directory to current file directory if unset.
    let $VIMLOCAL = expand('<sfile>:p:h').'/local'
endif
if has('nvim')
    set inccommand=split
endif

filetype plugin on
runtime macros/matchit.vim
let g:omni_sql_no_default_maps = 1

set title
set ruler
set cursorline
set nonumber
set laststatus=3
set signcolumn=number
set nowrap
set nowrapscan
set incsearch
set ignorecase smartcase
set list listchars=tab:▸\ ,trail:·,precedes:←,extends:→,nbsp:·
set backspace=indent,eol,start
set selection=inclusive
set autoread
set history=100
set hidden
set diffopt+=vertical,iwhite,hiddenoff
set fileformats=unix,dos
set fileignorecase
set virtualedit=all
set spelllang=en
set nostartofline
set mouse=nicr
set scrolljump=3
set splitright splitbelow
set foldmethod=indent foldlevel=99
set completeopt=noinsert,menuone,noselect
set formatoptions^=j " default in nvim but not vim

set autoindent smartindent
set expandtab tabstop=4 shiftwidth=0 softtabstop=-1

call matchadd('ColorColumn', '\%101v.', 100) " Character limit highlight
set iminsert=0 imsearch=-1 " Prevent starting in Kana

" undo/swap/temp in designated folders. nvim autocreates directories but vim does not.
set undofile
set undodir=$VIMLOCAL/undo
if !isdirectory($VIMLOCAL.'/undo')
    call mkdir($VIMLOCAL.'/undo')
endif
set backupdir=$VIMLOCAL/backup
if !isdirectory($VIMLOCAL.'/backup')
    call mkdir($VIMLOCAL.'/backup')
endif
set noswapfile " swap prevents opening the same file in diff instances.
set directory=$VIMLOCAL/swap " keep files separate if turned on.
if !isdirectory($VIMLOCAL.'/swap')
    call mkdir($VIMLOCAL.'/swap')
endif

set wildmenu
set wildignorecase
set wildmode=longest:full
set wildignore+=*.zip,*.tar,*.tar*,*.rar        " archive
set wildignore+=*.png,*.jpg,*.jpeg,*.gif        " images
set wildignore+=*.pdf,*.gem,*.obj,*.out,*.swp
let &wildcharm=&wildchar

let g:guid_regex = '[a-fA-F0-9]\{8,8}\(-[a-fA-F0-9]\{4,4}\)\{3,3}-[a-fA-F0-9]\{12,12}'

syntax on
set termguicolors
colorscheme desert

set background=dark
highlight EndOfBuffer guifg=bg
highlight Pmenu guifg=#CCCCCC guibg=#000022
highlight PmenuSel guifg=#000022 guibg=#CCCCCC
highlight MatchParen guifg=fg

if has('autocmd')
    augroup MarkdownFileType
        autocmd!
        autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
    augroup END

    augroup CSharp
        autocmd!
        autocmd BufReadPost *.{cs} silent call TFCheckout()
    augroup END

    if has('nvim')
        augroup Term
            autocmd!
            autocmd TermOpen * silent setlocal nonumber
        augroup END
    endif
    if has('terminal')
        augroup Term
            autocmd!
            autocmd TerminalOpen * silent setlocal nonumber
        augroup END
    endif
endif
