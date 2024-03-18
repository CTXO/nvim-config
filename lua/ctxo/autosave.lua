vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI"}, {
  pattern = {"*"},
  callback = function(ev)
	if vim.fn.expand("%:p") ~= "" then
		vim.cmd("silent write")
	end
  end
})

