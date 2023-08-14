return {
  'rmagatti/auto-session',
  event  = "VeryLazy",
  config = function()
    require("auto-session").setup {
      log_level = "error",
      auto_session_suppress_dirs = { "~/.config/*", "~/workspace/*", "~/Code/*", "/" },
    }

    -- autocmd BufWritePost *.py !your-command
    --
    -- vim.keymap.set("n", "<leader><Space>", ":SessionRestore <CR>")
    -- vim.cmd [[
    --         au BufWritePost * SessionSave
    --         ]]
  end
}
