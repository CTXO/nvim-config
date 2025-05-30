vim.cmd([[ set nu rnu ]])
vim.cmd([[ filetype indent on ]])
vim.cmd([[ filetype plugin indent on ]])
vim.cmd([[ set tabstop=4 ]])
vim.cmd([[ set shiftwidth=4 ]])

vim.opt.autowriteall = false
vim.opt.autowrite = false
vim.opt.hlsearch = true
vim.opt.scrolloff = 8
vim.o.mouse = 'a'
-- vim.opt.updatetime = 50
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- vim.opt.iskeyword:remove("_")
vim.opt.wildmenu = true
-- Very slow on big projects
-- vim.opt.path:append("**")
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.ruler = false
vim.o.completeopt = "menu,menuone,noinsert,noselect"
vim.o.breakindent = true
vim.o.breakindentopt = 'sbr'
vim.o.undofile = true

vim.o.updatetime = 250
vim.o.inccommand = 'split'
vim.o.cursorline = false
vim.o.confirm = true
vim.o.signcolumn = 'yes'
vim.opt.cursorlineopt = 'screenline,number'
vim.o.cursorcolumn = true

vim.opt.list = false

local limitedChars = {tab = '» ', trail = '·', lead = '-', leadmultispace = '---_', nbsp = '␣' }
local busyChars = {
  eol = '↲', tab = '» ', space = '␣', trail = '·', lead = '-', leadmultispace = '---_',
  extends = '☛', precedes = '☚', conceal = '┊', nbsp = '☠', multispace = '␣␣␣_'
}
vim.api.nvim_create_user_command("LimitedChars", function()
  vim.opt.listchars = limitedChars
  vim.opt.list = true
end, { desc = "Set listchars to limited" })

vim.api.nvim_create_user_command("BusyChars", function()
  vim.opt.listchars = busyChars
  vim.opt.list = true
end, { desc = "Set listchars to busy" })


vim.api.nvim_create_user_command("NoChars", function()
  vim.opt.list = false
end, { desc = "Disable listchars" })


-- ---
-- When editing a file, always jump to the last known cursor position.
-- Don't do it when the position is invalid, when inside an event handler
-- (happens when dropping a file on gvim) and for a commit message (it's
-- likely a different one than last time).
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function(args)
    local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line('$')
    local not_commit = vim.b[args.buf].filetype ~= 'commit'

    if valid_line and not_commit then
      vim.cmd([[normal! g`"]])
    end
  end,
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
	-- Check which register was used for the yank
	local event = vim.v.event
	local reg = event.regname
	local higroup = 'LocalYank'
	if reg == '+' then
		higroup = 'SystemYank'
	end

    vim.hl.on_yank({
			timeout = 350,
			higroup = higroup,
			priority = 300,
		})
  end,
})

-- Add support for Django static and templates folders
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = {'*.html', '*.py'},
  callback = function()
	-- Check if current buffer is a file 
    vim.opt_local.path:append("*/static/")
    vim.opt_local.path:append("static/")
    vim.opt_local.path:append("*/templates/")
    vim.opt_local.path:append("templates/")
  end
})
