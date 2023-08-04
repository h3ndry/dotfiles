return {
    'rmagatti/auto-session',
    config = function()
        require("auto-session").setup {
            log_level = "error",
            auto_session_suppress_dirs = { "~/.config/*", "~/workspace/*", "~/Code/*", "/" },
        }
        vim.keymap.set("n", "<leader><Space>", ":SessionRestore <CR>")
        vim.cmd [[
            au VimLeave,VimLeavePre  * SessionSave
            ]]
    end
}
