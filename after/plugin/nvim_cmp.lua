local cmp = require('cmp')

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			local ok, ls = pcall(require, 'luasnip')
			  if ok then
				ls.lsp_expand(args.body)
			  else
				vim.snippet.expand(args.body)
			  end
		end,
	},
	mapping = cmp.mapping.preset.insert({
		-- `Enter` key to confirm completion
		['<C-y>'] = cmp.mapping.confirm({select = true}),

		-- Ctrl+Space to trigger completion menu
		['<C-Space>'] = cmp.mapping.complete(),

		-- Scroll up and down in the completion documentation
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	}, {
			{ name = 'buffer' },
		}),
	performance = {
		debounce = 100,
		throttle = 50,
		max_view_entries = 50,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		documentation = {
			max_width = 50,
			max_height = 10
		}
	}
})



vim.opt.pumheight = 10

-- cmp.setup.cmdline({ '/', '?' }, {
-- 	mapping = cmp.mapping.preset.cmdline(),
-- 	sources = {
-- 		{ name = 'buffer' }
-- 	}
-- })
--
-- cmp.setup.cmdline(':', {
-- 	mapping = cmp.mapping.preset.cmdline(),
-- 	sources = cmp.config.sources({
-- 		{ name = 'path' }
-- 	}, {
-- 			{ name = 'cmdline' }
-- 		}),
-- 	matching = { disallow_symbol_nonprefix_matching = false }
-- })
--

local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- require('lspconfig')['pyright'].setup {
-- 	capabilities = capabilities
-- }

-- require('lspconfig')['ruff'].setup {
-- 	capabilities = capabilities
-- }
