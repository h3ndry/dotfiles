local cmd = vim.api.nvim_command

-- Disable few unused builtin plugins
local disable_distribution_plugins = function()
    -- Disable menu loading
    cmd([[let g:did_install_default_menus = 1]])
    cmd([[let g:did_install_syntax_menu = 1]])

    -- Uncomment this if you define your own filetypes in `after/ftplugin`
    -- cmd([[let g:did_load_filetypes = 1]])

    -- Do not load native syntax completion
    cmd([[let g:loaded_syntax_completion = 1]])

    -- Do not load spell files
    cmd([[let g:loaded_spellfile_plugin = 1]])

    -- -- Whether to load netrw by default
    -- cmd([[let g:loaded_netrw = 1]])
    -- cmd([[let g:loaded_netrwFileHandlers = 1]])
    -- cmd([[let g:loaded_netrwPlugin = 1]])
    -- cmd([[let g:loaded_netrwSettings = 1]])
    -- -- newtrw liststyle: https://medium.com/usevim/the-netrw-style-options-3ebe91d42456
    -- -- cmd([[let g:netrw_liststyle = 3]])

    -- Do not load tohtml.vim
    cmd([[let g:loaded_2html_plugin = 1]])

    -- Do not load zipPlugin.vim, gzip.vim and tarPlugin.vim (all these plugins are
    -- related to checking files inside compressed files)
    cmd([[let g:loaded_gzip = 1]])
    cmd([[let g:loaded_tarPlugin = 1]])
    cmd([[let g:loaded_vimball = 1]])
    cmd([[let g:loaded_vimballPlugin = 1]])
    cmd([[let g:loaded_zipPlugin = 1]])

    -- Do not use builtin matchit.vim and matchparen.vim since the use of vim-matchup
    cmd([[let g:loaded_matchit = 1]])
    cmd([[let g:loaded_matchparen = 1]])

    -- Disable sql omni completion.
    cmd([[let g:loaded_sql_completion = 1]])

    -- Disable remote plugins
    -- NOTE: Disabling rplugin.vim will show error for `wilder.nvim` in :checkhealth,
    -- NOTE:  but since it's config doesn't require python rtp, it's fine to ignore.
    cmd([[let g:loaded_remote_plugins = 1]])
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
vim.keymap.set("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("lazy").setup("plugins")



require "utils.setting"
require "utils.keymap"


-- --       𥉉  ﮏ   ﰸ  
--                      
local signs = { Error = "", Warn = "", Hint = "", Info = "i" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- changing lightspeed colors
vim.api.nvim_exec(
    [[
    highlight! LightspeedOneCharMatch guibg=#0d1117 guifg=NONE
    highlight! LightspeedCursor guibg=#FFFF00 guifg=#000000
    :hi Normal guibg=NONE ctermbg=NONE
    highlight! Normal guibg=NONE ctermbg=NONE
]]   ,
    false
)


