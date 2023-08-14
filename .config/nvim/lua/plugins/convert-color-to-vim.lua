return {
  "prettier/vim-prettier",
  event = "VeryLazy",
  ft    = {
    "javascript",
    "typescript",
    "typescriptreact",
    "css",
    "less",
    "scss",
    "json",
    "graphql",
    "markdown",
    "vue",
    "svelte",
    "yaml",
    "html"
  },
  build = "yarn install"
}
