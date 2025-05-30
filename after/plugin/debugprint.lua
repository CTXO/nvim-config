local debugprint = require('debugprint')
local counter = 0

local counter_func = function()
    counter = counter + 1
    return '[' .. tostring(counter) .. ']'
end

debugprint.setup({
	display_counter = counter_func,
	keymaps = {
		normal = {
			plain_below = "<leader>ip",
			plain_above = "<leader>iP",
			variable_below = "<leader>iv",
			variable_above = "<leader>iV",
			variable_below_alwaysprompt = "<leader>ia",
			variable_above_alwaysprompt = "<leader>iA",
			surround_plain = "<leader>isp",
			surround_variable = "<leader>isv",
			surround_variable_alwaysprompt = "<leader>isa",
			textobj_below = "<leader>io",
			textobj_above = "<leader>iO",
			textobj_surround = "<leader>iso",
			toggle_comment_debug_prints = "",
			delete_debug_prints = "<leader>id",
		},
		insert = {
			plain = "<C-G>p",
			variable = "<C-G>v",
		},
		visual = {
			variable_below = "<leader>iv",
			variable_above = "<leader>iV",
		},
	},
})

-- vim.keymap.set('n', 'g?d', '<cmd>DeleteDebugPrints<CR>')
vim.keymap.set('n', '<leader>ic', '<cmd>ToggleCommentDebugPrints<CR>')
vim.keymap.set('n', '<leader>if', '<cmd>SearchDebugPrints<CR>')
