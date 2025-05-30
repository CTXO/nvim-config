-- vim.keymap.set("n", "<leader>ce", ":Copilot enable<CR>")
-- vim.keymap.set("n", "<leader>cd", ":Copilot disable<CR>")
-- vim.keymap.set("n", "<leader>cs", ":Copilot status<CR>")


vim.keymap.set('i', '<C-L>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true

