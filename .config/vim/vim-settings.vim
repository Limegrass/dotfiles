if $VIMCONFIG == '' " set config directory to current file directory if unset.
    let $VIMCONFIG = expand('<sfile>:p:h')
endif
if has('nvim')
    set inccommand=split
endif

filetype plugin on
runtime macros/matchit.vim
let g:omni_sql_no_default_maps = 1

set title
set lazyredraw
set ruler
set cursorline
set number
set nowrap
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

set wildmenu wildignorecase wildmode=longest:full
set wildignore+=*.zip,*.tar,*.tar*,*.rar        " archive
set wildignore+=*.png,*.jpg,*.jpeg,*.gif        " images
set wildignore+=*.pdf,*.gem,*.obj,*.out,*.swp

let g:guid_regex = '[a-fA-F0-9]\{8,8}\(-[a-fA-F0-9]\{4,4}\)\{3,3}-[a-fA-F0-9]\{12,12}'

syntax on
set termguicolors
colorscheme desert

set background=dark
highlight EndOfBuffer guifg=bg
highlight Pmenu guifg=#CCCCCC guibg=#000022
highlight PmenuSel guifg=#000022 guibg=#CCCCCC
highlight MatchParen guifg=fg
