function pad_to_center(text)
	local win_width = vim.api.nvim_win_get_width(0)
	local half_width = math.floor(win_width / 2)
	local text_len = string.len(text)
	local half_text_len = math.floor(text_len / 2)
	local test = 50
	local partial_str = string.format("%%%ds", half_width - half_text_len)
	return string.format(partial_str, test, text)
end
print(pad_to_center("hello"))
