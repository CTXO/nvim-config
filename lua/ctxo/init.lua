vim.cmd('colorscheme rose-pine')


vim.cmd([[ set nu rnu ]])
vim.cmd([[ filetype indent on ]])
vim.cmd([[ filetype plugin indent on ]])
vim.cmd([[ set tabstop=4 ]])
vim.cmd([[ set shiftwidth=4 ]])
vim.cmd([[ set nocompatible ]])


vim.opt.hlsearch = false
vim.opt.scrolloff = 8
vim.opt.updatetime = 50


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


