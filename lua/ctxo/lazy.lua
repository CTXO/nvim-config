local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{
			'nvim-telescope/telescope.nvim', branch = '0.1.x',
			dependencies = { {'nvim-lua/plenary.nvim'} }
		},
		{"smartpde/telescope-recent-files"},

		"debugloop/telescope-undo.nvim",

		{
			'nvim-telescope/telescope-fzf-native.nvim',
			build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' 
		},
		{ 'nvim-telescope/telescope-ui-select.nvim' },
		'catgoose/telescope-helpgrep.nvim',

		{
			"chrisgrieser/nvim-various-textobjs",
			event = "VeryLazy",
			opts = {
				keymaps = {
					useDefaults = true
				}
			},
		},
		"neovim/nvim-lspconfig",


		{
			'nvim-treesitter/nvim-treesitter',
			build = ':TSUpdate'
		},
		'nvim-treesitter/nvim-treesitter-context',
		{
			-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
			-- used for completion, annotations and signatures of Neovim apis
			'folke/lazydev.nvim',
			ft = 'lua',
			opts = {
				library = {
					-- Load luvit types when the `vim.uv` word is found
					{ path = '${3rd}/luv/library', words = { 'vim%.uv' } },
					{"nvim-dap-ui"},
					{'nvim-treesitter/nvim-treesitter-context',}
				},
			},
		},
		{
			"andrewferrier/debugprint.nvim",
			version = "*", 
		},
		'mason-org/mason.nvim',
		'mason-org/mason-lspconfig.nvim',
		-- 'WhoIsSethDaniel/mason-tool-installer.nvim',

		'hrsh7th/nvim-cmp',
		'hrsh7th/cmp-nvim-lsp',
		'L3MON4D3/LuaSnip',
		'saadparwaiz1/cmp_luasnip',

		'mfussenegger/nvim-dap',
		'mfussenegger/nvim-dap-python',
		{ "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} },


		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			config = true,
		},

		{
			"cbochs/grapple.nvim",
			dependencies = {
				{ "nvim-tree/nvim-web-devicons", lazy = true }
			},
		},

		'michaeljsmith/vim-indent-object',

		-- 'ryanoasis/vim-devicons',

		-- use {'ojroques/nvim-hardline'}
		-- 'ThePrimeagen/vim-be-good',
		--
		'github/copilot.vim',

		"kylechui/nvim-surround",

		-- 'karb94/neoscroll.nvim',

		'uga-rosa/ccc.nvim',


		{
			'stevearc/oil.nvim',
			---@module 'oil'
			---@type oil.SetupOpts
			opts = {},
			lazy = false,
		},

		{
			"m4xshen/hardtime.nvim",
			lazy = false,
			dependencies = { "MunifTanjim/nui.nvim" },
		},

		"dimfred/resize-mode.nvim",

		'windwp/nvim-ts-autotag',

		'Mofiqul/dracula.nvim',

		'rebelot/kanagawa.nvim',

		{
			"nickkadutskyi/jb.nvim",
			lazy = false,
			priority = 1000,
			opts = {},
		},

	},




	install = { colorscheme = { "dracula-soft" } },
	checker = { enabled = true, frequency = 86400},

})

vim.cmd('colorscheme jb')
vim.cmd('hi TelescopePreviewLine guibg=#32426b')
vim.cmd('hi Python_SpecialNames_Definition guifg=#94558d')
vim.cmd('hi StatusLine guifg=#b3e260 guibg=#000000')
vim.cmd('hi StatusLineNC guifg=#9a9ca4 guibg=#000000')
vim.api.nvim_set_hl(0, "SystemYank", {bg="#114957"})
vim.api.nvim_set_hl(0, "LocalYank", {bg="#3b3c3e"})


