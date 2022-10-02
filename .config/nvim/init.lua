require("plugins")

-- avoid plug before sourcing base vimrc
vim.g.use_plug = 0
vim.cmd([[
    source $HOME/.config/vim/vimrc
]])

vim.env.NVIMINIT = vim.fn.expand("<sfile>:p")
