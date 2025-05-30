dap = require('dap')
dapui = require('dapui')

dapui.setup({
	icons = { expanded = "▾", collapsed = "▸", current_frame = "★" },
}
)

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end



vim.keymap.set('n', '<leader>b', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<leader>B', function() dap.toggle_breakpoint(vim.fn.input("Condition: ")) end)
vim.keymap.set('n', '<leader>lt', function() dap.terminate() end)
vim.keymap.set('n', '<leader>lo', function() dapui.open() end)
vim.keymap.set('n', '<leader>lc', function() dapui.close() end)

vim.keymap.set('n', '<leader>ls', function() dap.continue() end)
vim.keymap.set('n', '<F5>', function() dap.continue() end)
vim.keymap.set('n', '<F6>', function() dap.step_over() end)
vim.keymap.set('n', '<F7>', function() dap.step_into() end)
vim.keymap.set('n', '<F8>', function() dap.step_out() end)

-- python
require("dap-python").setup("python3")
table.insert(dap.configurations.python, 1, {
  type = 'python',
  request = 'launch',
  name = 'Django',
  program = vim.fn.getcwd() .. '/manage.py',
  args = {'runserver', '8080'},
  django = true,
  cwd = vim.fn.getcwd(),
  justMyCode = false,
})


