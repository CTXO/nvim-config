local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {},
  handlers = {
    lsp_zero.default_setup,
  },
})



local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    -- `Enter` key to confirm completion
    ['<CR>'] = cmp.mapping.confirm({select = false}),

    -- Ctrl+Space to trigger completion menu
    ['<C-Space>'] = cmp.mapping.complete(),

    -- Navigate between snippet placeholder
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),

    -- Scroll up and down in the completion documentation
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
  })
})
vim.diagnostic.config({ virtual_text = false })

local diagnostics_active = false
function toggle_diagnostics()
  if diagnostics_active then
    diagnostics_active = false
	vim.diagnostic.disable()
	print("Diagnostics disabled")
  else
    diagnostics_active = true
	print("Diagnostics enabled")
	vim.diagnostic.enable()
  end
end

local virtual_text_active = false
function toggle_virtual_text()
	if virtual_text_active then
		virtual_text_active = false
		print("Virtual text disabled")
		vim.diagnostic.config({ virtual_text = false })
	else 
		virtual_text_active = true
		print("Virtual text enabled")
		vim.diagnostic.config({ virtual_text = true })
	end
end




vim.api.nvim_set_keymap('n', '<leader><leader>', '<cmd>lua toggle_diagnostics()<CR>',  {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<leader>v', '<cmd>lua toggle_virtual_text()<CR>',  {noremap = true, silent = true})


vim.api.nvim_set_keymap('n', '<leader>k', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })

