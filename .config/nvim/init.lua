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




local opts = { noremap = true, silent = true }
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
}
)

require "utils.setting"
require "utils.keymap"



-- -- --       𥉉  ﮏ   ﰸ  
-- --                      
-- local signs = { Error = "", Warn = "", Hint = "", Info = "i" }
-- for type, icon in pairs(signs) do
--     local hl = "DiagnosticSign" .. type
--     vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
-- end


vim.cmd([[
    se stl:— fcs=stl:─,stlnc:—

    hi LineNrAbove guifg=#665c54
    hi LineNr guifg=#fd8019
    hi LineNrBelow guifg=#665c54

    hi Cursorline guibg=#665c54

    hi FoldColumn guibg=NONE
    " hi GitSignsAdd guibg=NONE
    " hi GitSignsChange guibg=NONE
    " hi GitSignsDelete guibg=NONE

    hi SignColumn guibg=NONE ctermbg=NONE
    hi Folded guibg=NONE ctermbg=NONE
    hi NormalFloat guibg=NONE ctermbg=NONE
    hi FloatBorder guibg=NONE ctermbg=NONE

    hi WinSeparator guibg=NONE ctermbg=NONE
    hi WinBar guibg=NONE ctermbg=NONE
    hi WinBarNC guibg=NONE ctermbg=NONE

    hi Normal guibg=NONE ctermbg=NONE
    hi PMenuSel guibg=#665c54 ctermbg=NONE guifg=#fd8019
    hi PMenu guibg=NONE ctermbg=NONE
    hi PMenuSBar guibg=NONE  ctermbg=NONE
    hi PMenuThumb guibg=NONE ctermbg=NONE
    hi WildMenu guibg=NONE ctermbg=NONE
    hi VertSplit ctermbg=NONE guibg=NONE


    hi StatusLine gui=NONE guifg=#665c54 guibg=NONE
    hi StatusLineNC gui=NONE guifg=#665c54 guibg=NONE

    " hi Search guifg=#665c54 guibg=white

    hi TabLineFill guifg=NONE guibg=NONE
    hi TabLine guifg=#665c54  guibg=NONE
    hi TabLineSel guifg=#fd8019 guibg=NONE

    hi GitSignsAdd guifg=#b8bb26 guibg=NONE
    hi GitSignsDelete guifg=#fb4934 guibg=NONE
    hi GitSignsChange guifg=#8ec07c guibg=NONE
    hi DiagnosticSign guibg=NONE

    " hi IncSearch gui=NONE guifg=#82a597 guibg=#504945
    " hi CurSearch gui=NONE guifg=#504945 guibg=#82a597

    " autocmd InsertEnter * set cul
    " autocmd InsertLeave * set nocul
    set exrc
    set secure

]])
