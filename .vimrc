" ==============================================================================
" Author: James Ni (Limegrass) - @Multipoke
" ==============================================================================
set fileformat=unix
set encoding=utf-8
scriptencoding utf-8

let $HOME = substitute($HOME, '\', '/', 'g') " normalizes for Windows

let $VIMDIR = $HOME.'/.vim'
set runtimepath^=$VIMDIR,$VIMDIR/after

" sets this file as $MYVIMRC regardless of sourcing method
let $MYVIMRC = expand('<sfile>:p')

" ==============================================================================
" SUBCONFIGS
" ==============================================================================
source $VIMDIR/function-definitions.vim
source $VIMDIR/vim-settings.vim
source $VIMDIR/keymaps.vim
source $VIMDIR/plugin-settings.vim

let $GARBAGEDIR = $HOME.'/garbage' " default working directory in my workflow.
if !isdirectory($GARBAGEDIR)
    silent call mkdir($GARBAGEDIR)
endif

