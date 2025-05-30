local api = vim.api
ns = api.nvim_create_namespace('rel_lines')
vim.b.relvirt_disabled = true

local function is_blank(buf, lnum)
  local line = vim.api.nvim_buf_get_lines(buf, lnum, lnum + 1, false)[1] or ""
  return line:match("^%s*$") ~= nil
end

local function render_line(buf, lnum, cur)
  local rel = math.abs(cur - lnum)
  local text = (rel == 0 or is_blank(buf, lnum)) and "" or string.format('%d', rel)

  api.nvim_buf_set_extmark(buf, ns, lnum, 0, {
    id = lnum + 1,
    virt_text = { { text, 'LineNr' } },
    virt_text_pos = 'eol',
    hl_mode = 'combine',
  })
end

local function refresh(buf, win)
  win = win or api.nvim_get_current_win()

  local cur = api.nvim_win_get_cursor(win)[1] - 1
  local topline = vim.fn.line('w0', win) - 1
  local botline = vim.fn.line('w$', win) - 1
  local lastline = api.nvim_buf_line_count(buf) - 1

  topline = math.max(0, topline)
  botline = math.min(lastline, botline)

  api.nvim_buf_clear_namespace(buf, ns, topline, botline)

  for l = topline, botline do
    render_line(buf, l, cur)
  end
end

function clearMarks()
  api.nvim_buf_clear_namespace(api.nvim_get_current_buf(), ns, 0, -1)
end

api.nvim_create_autocmd({'BufWinEnter', 'CursorMoved', 'WinScrolled' }, {
  group = api.nvim_create_augroup('RelVirt', { clear = true }),
  callback = function(ev)
		if not vim.b.relvirt_disabled then
			refresh(ev.buf, ev.win)
		end
	end,
})

vim.keymap.set('n', '<leader>rv', function()
  if not vim.b.relvirt_disabled then
    api.nvim_buf_clear_namespace(0, ns, 0, -1)
    vim.b.relvirt_disabled = true
  else
    vim.b.relvirt_disabled = false
    vim.cmd('doautocmd <nomodeline> CursorMoved')
  end
end, { desc = 'Toggle virtual relative numbers' })

