return {
    "jackMort/ChatGPT.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "folke/which-key.nvim",
        "nvim-telescope/telescope.nvim"
    },
    event = "VeryLazy",
    config = function()
        local wk = require("which-key")
        local chatgpt = require("chatgpt")
        chatgpt.setup({
            openai_params = {
                model = "gpt-4",
            },
        })

        wk.register({
            p = {
                name = "ChatGPT",
                e = {
                    function()
                        chatgpt.edit_with_instructions()
                    end,
                    "Edit with instructions",
                },
            },
        }, {
            prefix = "<leader>",
            mode = "v",
        })
    end,
}
