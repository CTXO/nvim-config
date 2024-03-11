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


-- local cmp = require('cmp')
-- local cmp_select_opts = {behavior = cmp.SelectBehavior.Select}
-- 
-- -- Default config of cmp but limit entry number
-- local max_entries = 10
-- cmp.setup({
--   sources = {
--     {name = 'nvim_lsp'},
--   },
--   mapping = {
--     ['<C-y>'] = cmp.mapping.confirm({select = true}),
--     ['<Tab>'] = cmp.mapping.confirm({select = true}),
--     ['<Return>'] = cmp.mapping.confirm({select = true}),
--     ['<C-e>'] = cmp.mapping.abort(),
--     ['<C-u>'] = cmp.mapping.scroll_docs(-4),
--     ['<C-d>'] = cmp.mapping.scroll_docs(4),
--     ['<Up>'] = cmp.mapping.select_prev_item(cmp_select_opts),
--     ['<Down>'] = cmp.mapping.select_next_item(cmp_select_opts),
--     ['<C-p>'] = cmp.mapping(function()
--       if cmp.visible() then
--         cmp.select_prev_item(cmp_select_opts)
--       else
--         cmp.complete()
--       end
--     end),
--     ['<C-n>'] = cmp.mapping(function()
--       if cmp.visible() then
--         cmp.select_next_item(cmp_select_opts)
--       else
--         cmp.complete()
--       end
--     end),
--   },
--   snippet = {
--     expand = function(args)
--       require('luasnip').lsp_expand(args.body)
--     end,
--   },
--   window = {
--     documentation = {
--       max_height = 15,
--       max_width = 60,
--     }
--   },
--   formatting = {
--     fields = {'abbr', 'menu', 'kind'},
--     format = function(entry, item)
--       local short_name = {
--         nvim_lsp = 'LSP',
--         nvim_lua = 'nvim'
--       }
-- 
--       local menu_name = short_name[entry.source.name] or entry.source.name
-- 
--       item.menu = string.format('[%s]', menu_name)
--       return item
--     end,
--   },
--   performance = {
-- 	  max_view_entries = max_entries
--   }
-- })
-- 
-- lsp_zero.setup()
--
--

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

