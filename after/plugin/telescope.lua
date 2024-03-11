local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>fr', builtin.lsp_references, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
-- vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fs', builtin.grep_string, {})


-- Load extension.
require("telescope").load_extension("recent_files")
vim.api.nvim_set_keymap("n", "<leader>fk",
  [[<cmd>lua require('telescope').extensions.recent_files.pick()<CR>]],
  {noremap = true, silent = true})
