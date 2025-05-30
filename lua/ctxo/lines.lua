vim.keymap.set('n', '<leader>rt', function()
  if vim.wo.relativenumber then
	vim.wo.relativenumber = false
  else
	vim.wo.relativenumber = true
  end
end, { desc = 'Toggle relative numbers' })

vim.opt.showbreak = '->> '
local has_showbreak = true

vim.keymap.set('n', '<leader>rb', function()
  if has_showbreak then
	vim.opt.showbreak = ''
	has_showbreak = false
  else
	vim.opt.showbreak = '->> '
	has_showbreak = true
  end
end, { desc = 'Toggle showbreak' })
