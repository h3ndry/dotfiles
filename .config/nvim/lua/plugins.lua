-- Install packer
local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

vim.api.nvim_exec(
  [[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]],
  false
)
-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
-- Only if your version of Neovim doesn't have https://github.com/neovim/neovim/pull/12632 merged

local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({"git", "clone", "https://github.com/wbthomason/packer.nvim", install_path})
  execute "packadd packer.nvim"
end

return require("packer").startup(
  function(use)
    -- Packer can manage itself
    use "wbthomason/packer.nvim"
    use "tpope/vim-commentary"
    use "h3ndry/ReplaceWithRegister"
    use "tpope/vim-repeat"
    use "cohama/lexima.vim"
    use "h3ndry/vim-sandwich"
    use "h3ndry/tokyonight.nvim"
    use "SirVer/ultisnips"
    use "honza/vim-snippets"
    use "neovim/nvim-lspconfig"
    use "hrsh7th/nvim-compe"
    use "kabouzeid/nvim-lspinstall"
    use "nvim-lua/lsp_extensions.nvim"
    use "hrsh7th/vim-vsnip"
    use "hrsh7th/vim-vsnip-integ"
    use "OrangeT/vim-csharp"
    use "tpope/vim-capslock"
    use "nvim-treesitter/nvim-treesitter-textobjects"
    use "mhartington/formatter.nvim"
    use "norcalli/nvim-colorizer.lua"

    use {
      "glacambre/firenvim",
      run = function()
        vim.fn["firenvim#install"](0)
      end
    }

    -- if work.. work
    use {
      "lewis6991/gitsigns.nvim",
      requires = {
        "nvim-lua/plenary.nvim"
      }
    }

    -- Post-install/update hook with neovim command
    use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}
  end
)
