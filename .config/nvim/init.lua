local cmd = vim.api.nvim_command

local disable_distribution_plugins = function()
    cmd([[let g:loaded_netrwFileHandlers = 1]])
    cmd([[let g:loaded_netrwPlugin = 1]])
    cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
end

disable_distribution_plugins()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

vim.keymap.set("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local border = {
    { "╭", "FoldColumn" },
    { "─", "FoldColumn" },
    { "╮", "FoldColumn" },
    { "│", "FoldColumn" },
    { "╯", "FoldColumn" },
    { "─", "FoldColumn" },
    { "╰", "FoldColumn" },
    { "│", "FoldColumn" },
}

require("lazy").setup("plugins", {
    ui = { border = border },
    change_detection = {
        enabled = true,
        notify = false, -- get a notification when changes are found
    }
})

require "utils.setting"
require "utils.keymap"

vim.cmd([[
    se stl:— fcs=stl:─,stlnc:—

    hi FoldColumn guibg=NONE

    hi SignColumn guibg=NONE ctermbg=NONE
    hi Folded guibg=NONE ctermbg=NONE
    hi NormalFloat guibg=NONE ctermbg=NONE
    hi FloatBorder guibg=NONE ctermbg=NONE

    hi WinSeparator guibg=NONE ctermbg=NONE
    hi WinBar guibg=NONE ctermbg=NONE
    hi WinBarNC guibg=NONE ctermbg=NONE

    hi Normal guibg=NONE ctermbg=NONE
    hi NormalNC guibg=NONE ctermbg=NONE
    hi PMenu guibg=NONE ctermbg=NONE
    hi PMenuSBar guibg=NONE  ctermbg=NONE
    hi PMenuThumb guibg=NONE ctermbg=NONE
    hi WildMenu guibg=NONE ctermbg=NONE
    hi VertSplit ctermbg=NONE guibg=NONE

    hi StatusLine gui=NONE guifg=#282c34 guibg=NONE
    hi StatusLineNC gui=NONE guifg=#282c34 guibg=NONE
    hi VertSplit gui=NONE guifg=#282c34 guibg=NONE cterm=NONE

    hi TabLineFill guifg=NONE guibg=NONE
    hi TabLine guifg=#9fa7c8  guibg=NONE
    hi TabLineSel guifg=#fe6d85 guibg=NONE

    set exrc
    set secure

    set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
]])
