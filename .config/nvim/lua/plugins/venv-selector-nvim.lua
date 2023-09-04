return {
  "linux-cultist/venv-selector.nvim",
  dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
  event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
  keys = { {
    "<leader>vs", "<cmd>:VenvSelect<cr>",
    -- key mapping for directly retrieve from cache. You may set autocmd if you prefer the no hand approach
    "<leader>vc", "<cmd>:VenvSelectCached<cr>"
  } },
  config = function()
    local venv_selector = require("venv-selector")

    venv_selector.setup()

    vim.api.nvim_create_autocmd("VimEnter", {
      desc = "Auto select virtualenv Nvim open",
      pattern = "*",
      callback = function()
        local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
        if venv ~= "" then
          require("venv-selector").retrieve_from_cache()
        end
      end,
      once = true,
    })
  end


}
