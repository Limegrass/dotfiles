-- avoid plug before sourcing base vimrc
require("plugins")
vim.g.plugin_system = "packer"
vim.cmd([[
    source $HOME/.config/vim/vimrc
]])

vim.env.NVIMINIT = vim.fn.expand("<sfile>:p")
