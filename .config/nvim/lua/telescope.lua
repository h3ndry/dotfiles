return {
    "nvim-telescope/telescope.nvim",
    dependencies = 'kevinhwang91/promise-async',
    config = function()
        require("telescope").setup {
            defaults = {
                mappings = {
                    i = { ["<C-h>"] = "which_key" }
                }
            },
            pickers = {},
            extensions = {
                fzf = {
                    override_generic_sorter = false,
                    override_file_sorter = true
                },
            }
        }
        require("telescope").load_extension("fzf")
    end
}
