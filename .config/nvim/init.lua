-- avoid plug before sourcing base vimrc
vim.g.plugin_system = "lazy"
vim.cmd([[
    source $HOME/.config/vim/vimrc
]])

local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazy_path,
    })
end
vim.opt.rtp:prepend(lazy_path)

local lazy_opts = {
    change_detection = {
        enabled = true,
        notify = false,
    },
}

require("lazy").setup(
    {
        { import = "plugins" },
        { import = "nvim-cmp" },
    },
    lazy_opts
)

vim.opt.signcolumn = "no"

vim.env.NVIMINIT = vim.fn.expand("<sfile>:p")
