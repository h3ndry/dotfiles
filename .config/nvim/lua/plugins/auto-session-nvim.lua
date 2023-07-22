return {
    'rmagatti/auto-session',
    config = function()
        require("auto-session").setup {
            log_level = "error",
            auto_session_suppress_dirs = { "~/.config/*", "~/workspace/*", "~/Code/*", "/" },
        }

        local opts = { noremap = true, silent = true }

        vim.keymap.set("n", "<leader>qs", ":SessionRestore <CR>", opts)
        vim.cmd [[
            au FocusLost,TabLeave * stopinsert
            au FocusLost,TabLeave * SessionSave
            ]]
    end
}
