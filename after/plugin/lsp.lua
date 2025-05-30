local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })

local highlight_enabled = false
function enable_lsp_highlight(event)
	if event then
		buffer = event.buf
	else
		buffer = vim.api.nvim_get_current_buf()
	end
	vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
		buffer = buffer,
		group = highlight_augroup,
		callback = vim.lsp.buf.document_highlight,
	})

	vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
		buffer = buffer,
		group = highlight_augroup,
		callback = vim.lsp.buf.clear_references,
	})
	highlight_enabled = true
end

function disable_lsp_highlight(event)
	if event then
		buffer = event.buf
	else
		buffer = vim.api.nvim_get_current_buf()
	end
	vim.api.nvim_clear_autocmds { group = highlight_augroup, buffer = buffer }
	vim.lsp.buf.clear_references()
	highlight_enabled = false
end

function toggle_lsp_highlight()
	buffer = vim.api.nvim_get_current_buf()
	if highlight_enabled then
		disable_lsp_highlight()
		vim.notify("LSP Highlight disabled", vim.log.levels.INFO, { title = "LSP" })
	else
		enable_lsp_highlight()
		vim.notify("LSP Highlight enabled", vim.log.levels.INFO, { title = "LSP" })
	end
end


vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc, mode)
			mode = mode or 'n'
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
		end
		local function client_supports_method(client, method, bufnr)
			if vim.fn.has 'nvim-0.11' == 1 then
				return client:supports_method(method, bufnr)
			else
				return client.supports_method(method, { bufnr = bufnr })
			end
		end

		-- The following two autocommands are used to highlight references of the
		-- word under your cursor when your cursor rests there for a little while.
		--    See `:help CursorHold` for information about when this is executed
		--
		-- When you move your cursor, the highlights will be cleared (the second autocommand).
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
			enable_lsp_highlight(event)
			vim.api.nvim_create_autocmd('LspDetach', {
				group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
				end,
			})
			vim.keymap.set("n", "<leader>lh", toggle_lsp_highlight, { desc = "Toggle LSP Highlight" })

			-- The following code creates a keymap to toggle inlay hints in your
			-- code, if the language server you are using supports them
			--
			-- This may be unwanted, since they displace some of your code
			if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_definition, event.buf) then
				map('gd', function()
					vim.lsp.buf.definition { reuse_win = true }
				end, '[G]oto [D]efinition')
			end
			if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
				map('<leader>th', function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
				end, '[T]oggle Inlay [H]ints')
			end
		end
	end
})

vim.diagnostic.config({
	virtual_text = false,
	severity_sort = true,
	signs = {
		linehl = {
			[vim.diagnostic.severity.ERROR] = 'ErrorMsg',
		},
		numhl = {
			[vim.diagnostic.severity.WARN] = 'WarningMsg',
		},
	},
})

local cwd = vim.fn.getcwd()

local python_bin_path = cwd .. "/venv/bin"
local python_bin = python_bin_path .. "/python"

local get_python_site_packages = function()
	if vim.fn.isdirectory(python_bin_path) == 1 then
	  local handle = io.popen(python_bin .. " -c 'import sysconfig; print(sysconfig.get_paths()[\"purelib\"])'")
	  if not handle then return nil end
	  local result = handle:read("*a")
	  handle:close()
	  return vim.fn.trim(result)
	else
		return nil
	end
end

-- local site_packages = get_python_site_packages()


vim.lsp.config("djlsp", {
  cmd       = {"djlsp"},
  -- root_dir  = util.root_pattern("manage.py"),
  settings = {
    djlsp = {
      cache  = true,
    },
  },
  }
)
vim.lsp.enable("djlsp")

-- vim.lsp.config('pylsp', {
--   settings = {
-- 	pylsp = {
-- 	  plugins = {
-- 		rope_completion = { enabled = false },
-- 		rope_autoimport = { enabled = false },
-- 		jedi_completion = { enabled = true },
-- 		  pyflakes = { enabled = true },
-- 		  pycodestyle = { enabled = true },
-- 	  }
-- 	}
--   }
-- })

require('mason').setup()
require("mason-lspconfig").setup {
	ensure_installed = {"pyright"},
	automatic_installation = true,
    automatic_enable = {
        exclude = {
			"ruff",
			"pyright",
			"pylsp"
        }
    }
}




local diagnostics_active = true
function toggle_diagnostics()
  if diagnostics_active then
    diagnostics_active = false
	vim.diagnostic.enable(false)
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


vim.lsp.config('hls', {
  filetypes = { 'haskell', 'lhaskell', 'cabal' },
})

vim.lsp.enable('hls')

vim.api.nvim_set_keymap('n', '<leader><S-k>', '<cmd>lua toggle_diagnostics()<CR>',  {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<leader>v', '<cmd>lua toggle_virtual_text()<CR>',  {noremap = true, silent = true})


vim.api.nvim_set_keymap('n', '<leader>k', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'grR', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })

vim.lsp.enable("pyright")
vim.lsp.enable('ruff')
vim.lsp.config('html', {
	filetypes = { 'html', 'htmldjango' },
})

