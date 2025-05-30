require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "python" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
	enable = false,
  },
  select = {
		enable = true,
		include_surrounding_whitespace = true,
	}
}

require'treesitter-context'.setup{
  enable = false, -- Enable this plugin (Can be enabled/disabled later via commands)
  multiwindow = false, -- Enable multiwindow support.
  max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 20, -- Maximum number of lines to show for a single context
  trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = '—',
  zindex = 20, -- The Z-index of the context window
  on_attach = function(buf)
		return true
	end, -- (fun(buf: integer): boolean) return false to disable attaching
}

vim.keymap.set('n', '<leader>tc', ':TSContextToggle<CR>', { noremap = true, silent = true })


vim.wo.foldenable = false
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
