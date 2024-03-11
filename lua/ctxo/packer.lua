--This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]


return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- use {
  --     'nvim-telescope/telescope.nvim', tag = '0.1.1',
  --     -- or                            , branch = '0.1.x',
  --     requires = { {'nvim-lua/plenary.nvim'} }
  -- }

  use({ 'rose-pine/neovim', as = 'rose-pine' })

	  vim.cmd('colorscheme rose-pine')

  use ('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})

  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    requires = {
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},
  
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'L3MON4D3/LuaSnip'},
    }
  }
  

  use {
      "windwp/nvim-autopairs",
      config = function() require("nvim-autopairs").setup {} end
  }
  use({
      "kylechui/nvim-surround",
      tag = "*", -- Use for stability; omit to use `main` branch for the latest features
      config = function()
    	  require("nvim-surround").setup({
    		  -- Configuration here, or leave empty to use defaults
    	  })
      end
  })

  use 'michaeljsmith/vim-indent-object'
  -- use 'preservim/nerdtree'

	  -- use 'ryanoasis/vim-devicons'

  -- use {'ojroques/nvim-hardline'}
  -- use 'ThePrimeagen/vim-be-good'

end)


