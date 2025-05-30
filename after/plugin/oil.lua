local function copy_relpath()
  local oil   = require("oil")
  local entry = oil.get_cursor_entry()
  local dir   = oil.get_current_dir()
  if not entry or not dir then return end

  local abs = dir .. entry.name
  local rel = vim.fn.fnamemodify(abs, ':.')
  vim.fn.setreg('+', rel, 'c')
  vim.notify('copied: ' .. rel, vim.log.levels.INFO)
end
require('oil').setup({
	default_file_explorer = false,
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,
	columns = {
		"icon",
		"size"
	},
	keymaps = {
		["g?"] = { "actions.show_help", mode = "n" },
		["<CR>"] = "actions.select",
		["<C-s>"] = { "actions.select", opts = { vertical = true } },
		["<C-h>"] = { "actions.select", opts = { horizontal = true } },
		["<C-t>"] = { "actions.select", opts = { tab = true } },
		["<C-p>"] = "actions.preview",
		["<C-c>"] = { "actions.close", mode = "n" },
		["<C-l>"] = "actions.refresh",
		["-"] = { "actions.parent", mode = "n" },
		["_"] = { "actions.open_cwd", mode = "n" },
		["`"] = { "actions.cd", mode = "n" },
		["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
		["gs"] = { "actions.change_sort", mode = "n" },
		["gx"] = "actions.open_external",
		["g."] = { "actions.toggle_hidden", mode = "n" },
		["g\\"] = { "actions.toggle_trash", mode = "n" },
		["yp"] = { copy_relpath, mode = "n", desc = "copy relative path" },
		["yP"] = { "actions.copy_to_system_clipboard", mode= 'n' },
  },

})

vim.keymap.set("n", "<leader>o", function()
  require("oil").open()
end, { desc = "Open parent directory" })

vim.keymap.set("n", "<leader>O", function()
  require("oil").open(vim.fn.getcwd())
end, { desc = "Open cwd directory" })


