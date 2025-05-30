vim.opt.termguicolors = true

local ccc = require("ccc")
local mapping = ccc.mapping

ccc.setup({
  -- Your preferred settings
  -- Example: enable highlighter
  highlighter = {
	auto_enable = true,
	lsp = true,
  },
  preserve = true,
  save_on_quit = false,
})

-- toggle highlighter
vim.keymap.set("n", "<leader>th", ":CccHighlighterToggle<CR>", { desc = "Toggle Color Highlighter", silent = true })
vim.keymap.set("n", "<leader>tp", ":CccPick<CR>", { desc = "Toggle Color Highlighter", silent = true })




