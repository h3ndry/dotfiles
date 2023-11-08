return {
  "jackMort/ChatGPT.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "folke/which-key.nvim",
    "nvim-telescope/telescope.nvim"
  },
  event        = "VeryLazy",
  lazy         = true,
  -- commit       = "aa8a969",
  config       = function()
    local wk = require("which-key")
    local chatgpt = require("chatgpt")
    -- local home = vim.fn.expand("$HOME")
    chatgpt.setup({
      -- api_key_cmd = "cat ~/.jshi",
      openai_params = {
        max_tokens = 500,
        model = "gpt-4",
      },
    })

    wk.register({
      c = {
        name = "ChatGPT",
        e = { "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction" },
        g = { "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction" },
        t = { "<cmd>ChatGPTRun translate<CR>", "Translate" },
        k = { "<cmd>ChatGPTRun keywords<CR>", "Keywords" },
        d = { "<cmd>ChatGPTRun docstring<CR>", "Docstring" },
        -- a = { "<cmd>ChatGPTRun add_tests<CR>", "Add Tests" },
        o = { "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code" },
        s = { "<cmd>ChatGPTRun summarize<CR>", "Summarize" },
        f = { "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs" },
        x = { "<cmd>ChatGPTRun explain_code<CR>", "Explain Code" },
        r = { "<cmd>ChatGPTRun roxygen_edit<CR>", "Roxygen Edit" },
        l = { "<cmd>ChatGPTRun code_readability_analysis<CR>", "Code Readability Analysis" },
      },

    }, {
      prefix = "<leader>",
      mode = "v",
    })

    vim.keymap.set("n", "<leader>cc", ":ChatGPT <CR>")
    vim.keymap.set("n", "<leader>cC", ":ChatGPTActAs <CR>")
  end,
}
