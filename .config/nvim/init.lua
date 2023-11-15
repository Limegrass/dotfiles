-- avoid plug before sourcing base vimrc
require("plugins")
vim.g.plugin_system = "packer"
vim.cmd([[
    source $HOME/.config/vim/vimrc
]])

vim.opt.signcolumn = "no"
vim.opt.cmdheight = 0

vim.env.NVIMINIT = vim.fn.expand("<sfile>:p")
