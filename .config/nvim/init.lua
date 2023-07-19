local cmd = vim.api.nvim_command

-- Disable few unused builtin plugins
local disable_distribution_plugins = function()
    -- Disable loading loading
    cmd([[let g:did_install_default_menus = 1]])
    cmd([[let g:did_install_syntax_menu = 1]])
    -- Uncomment this if yogu define your own filetypes in `after/ftpluggin`
    cmd([[let g:did_load_filetypes = 1]])

    -- Do not load native syntax completion
    cmd([[let g:loaded_syntax_completion = 1]])

    -- Do not load spell files
    cmd([[let g:loaded_spellfile_plugin = 1]])

    -- Whether to load netrw by default
    -- cmd([[let g:loaded_netrw = 1]])
    -- cmd([[let g:loaded_netrwFileHandlers = 1]])
    cmd([[let g:loaded_netrwPlugin = 1]])
    -- cmd([[let g:loaded_netrwSettings = 1]])
    -- newtrw liststyle: https://medium.com/usevim/the-netrw-style-options-3ebe91d42456
    -- cmd([[let g:netrw_liststyle = 3]])

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


-- --       𥉉  ﮏ   ﰸ  
--                      
local signs = { Error = "", Warn = "", Hint = "", Info = "i" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end


vim.cmd([[
    se stl=─ fcs=stl:─,stlnc:-
    " se stl=- fcs=stl:-,stlnc:-

    " hi EndOfBuffer guifg=#b3b1ad  guibg=NONE

    " hi LineNrAbove guifg=#504945
    " hi LineNr guifg=#fd8019
    " hi LineNrBelow guifg=#504945

    hi Cursorline guibg=#504945

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
    hi PMenuSel guibg=#504945 ctermbg=NONE guifg=#fd8019
    hi PMenu guibg=NONE ctermbg=NONE
    hi PMenuSBar guibg=NONE  ctermbg=NONE
    hi PMenuThumb guibg=NONE ctermbg=NONE
    hi WildMenu guibg=NONE ctermbg=NONE
    hi VertSplit ctermbg=NONE guibg=NONE

    hi StatusLine cterm=NONE gui=NONE guifg=#504945 guibg=NONE
    hi StatusLineNC cterm=NONE gui=NONE guifg=#504945 guibg=NONE

    " autocmd InsertEnter * set cul
    " autocmd InsertLeave * set nocul
    set exrc
    set secure

]])
