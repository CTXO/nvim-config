local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>fr', builtin.lsp_references, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
-- vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>fs', builtin.grep_string, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fm', builtin.marks, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fc', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>fw', ":Telescope lsp_workspace_symbols query=", {})
vim.keymap.set('n', '<leader>fj', builtin.jumplist, {})

local telescope = require("telescope")
local telescopeConfig = require("telescope.config")

local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I want to search in .gitignored files.
table.insert(vimgrep_arguments, "--no-ignore")
 
-- I don't want to search in .git files.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

-- I don't want to search in __pychache__ files.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/__pycache__/*")


local exludeVenv = "!**/venv*/*"

local grepExcludeVenvOpts = {glob_pattern=exludeVenv}
local grepOpts = {prompt_title='Live Grep (All)'}
vim.keymap.set('n', '<leader>fg', function() builtin.live_grep(grepExcludeVenvOpts) end, {})
vim.keymap.set('n', '<leader>fG', function() builtin.live_grep(grepOpts) end, {})

-- Find directories in the working directory
local dir_comand = { "fd" , "--type", "d"}
local openDirInOil = function(prompt_bufnr, prepend_path)
    local action_state = require("telescope.actions.state")
    local actions = require("telescope.actions")
    local selection = action_state.get_selected_entry()

    if not selection then
        vim.notify("Telescope: No selection to open in Oil.", vim.log.levels.WARN)
        return
    end

    local path = selection.value -- This path comes directly from your `fd` command

    if not path or path == "" then
        vim.notify("Telescope: Selected path is empty.", vim.log.levels.WARN)
        return
    end

	if prepend_path then
		path = prepend_path .. "/" .. path
	end

    vim.notify("Telescope: Opening in Oil -> " .. path)

    actions.close(prompt_bufnr)

    require('oil').open(path)
end

local dir_search_opts = {
	find_command = dir_comand,
	prompt_title = "Directories",
	attach_mappings = function(_, map)
		map({"i", "n"}, "<C-y>", function(prompt_bufnr)
			openDirInOil(prompt_bufnr, false)
		end)

		map({"i", "n"}, "<CR>", function(prompt_bufnr)
			openDirInOil(prompt_bufnr, false)
		end)
		return true
	end
}

-- Find directories in the buffer current directory
local dir_local_search_opts = function()
	local cwd = vim.fn.expand('%:p:h')
	return {
		find_command = dir_comand,
		cwd = cwd,
		prompt_title=string.format("Directories: %s/", cwd),
		attach_mappings = function (_, map)
			map({"i", "n"}, "<C-y>", function(prompt_bufnr)
			openDirInOil(prompt_bufnr, cwd)
			end)
			return true
		end
	}
end

local switchPickers = function(picker, mode, opts)
	local opts = opts or {}
	return function(prompt_bufnr)
		local action_state = require("telescope.actions.state")
		local prompt = action_state.get_current_line()
		opts = vim.tbl_extend('force', opts, {
			default_text = prompt,
			initial_mode = mode,
		})
		picker(opts)
	end
end

local normalSwitch = function(picker, opts)
	return switchPickers(picker, "normal", opts)
end

local insertSwitch = function(picker, opts)
	return switchPickers(picker, "insert", opts)
end

local findFilesNoVenv = { "rg", "--files", "--hidden", "--no-ignore","--glob", "!**/.git/*", "--glob", "!**/__pycache__/*", "--glob", exludeVenv}
local findFilesWithVenv = { "rg", "--files", "--hidden", "--no-ignore","--glob", "!**/.git/*", "--glob", "!**/__pycache__/*"}
local find_venv_opts = {
	find_command = findFilesWithVenv,
	prompt_title = "Find Files (all)",
}

vim.keymap.set('n', '<leader>fa', function()builtin.find_files(find_venv_opts)end)

local register_mappings = {
	["<C-y>"] = require('telescope.actions').select_default,
	["<C-c>"] = function(prompt_bufnr)
		local action_state = require("telescope.actions.state")
		local selection = action_state.get_selected_entry()
		if selection then
			local register = string.lower(selection.value)
			local value = string.sub(selection.ordinal, 3, -1)
			local cmd = string.format("let @+=@%s", register)
			vim.cmd(cmd)
			local value_print = #{value} > 20 and string.sub(value, 1, 20) .. "..." or value
			print("Copied to clipboard: @" .. register)
		end
	end,
	["<C-q>"] = function(prompt_bufnr) require("telescope.actions").close(prompt_bufnr) end,
	["<M-e>"] = function(prompt_bufnr)
		local action_state = require("telescope.actions.state")
		local selection = action_state.get_selected_entry()

		if selection then
			local register = string.lower(selection.value)
			local left = vim.api.nvim_replace_termcodes("<Left>", true, false, true)
			local command  = string.format(":let @%s=''%s", register, left)
			local mode = vim.api.nvim_get_mode()["mode"]
			if mode == "i" then
				escape = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
				command = string.format("%s%s", escape, command)
			end
			vim.api.nvim_feedkeys(command, "n", true)
		end
	end,
	["<C-e>"] = function(prompt_bufnr)
		local action_state = require("telescope.actions.state")
		local selection = action_state.get_selected_entry()

		if selection then
			local register = string.lower(selection.value)
			local left = vim.api.nvim_replace_termcodes("<Left>", true, false, true)
			local register_value = vim.api.nvim_replace_termcodes(string.format("%s", register), true, false, true)

			local command  = string.format(":let @%s='%s'%s", register, register_value, left)
			local mode = vim.api.nvim_get_mode()["mode"]
			if mode == "i" then
				escape = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
				command = string.format("%s%s", escape, command)
			end
			vim.api.nvim_feedkeys(command, 'n', false)
		end
	end,
}

local register_mappings_n = {}
local register_mappings_i = {}

for k, v in pairs(register_mappings) do
	if register_mappings_n[k] == nil then
		register_mappings_n[k] = v
	end
	if register_mappings_i[k] == nil then
		register_mappings_i[k] = v
	end
end

telescope.setup({
	defaults = {
		vimgrep_arguments = vimgrep_arguments,
		mappings = {
			i = {
				["<C-f>"] = insertSwitch(require('telescope.builtin').find_files),
				["<C-a>"] = insertSwitch(require('telescope.builtin').find_files, find_venv_opts),
				["<C-g>g"] = insertSwitch(require('telescope.builtin').live_grep, grepExcludeVenvOpts),
				["<C-g><C-g>"] = insertSwitch(require('telescope.builtin').live_grep, grepExcludeVenvOpts),
				["<C-g>a"] = insertSwitch(require('telescope.builtin').live_grep, grepOpts),
				["<C-g><C-a>"] = insertSwitch(require('telescope.builtin').live_grep, grepOpts),
				["<C-S-J>"] = require('telescope.actions').cycle_history_next,
				["<C-S-K>"] = require('telescope.actions').cycle_history_prev,
				["<C-k>"] = insertSwitch(require('telescope').extensions.recent_files.pick),
				["<C-h>"] = insertSwitch(require('telescope.builtin').find_files, dir_search_opts),
				["<C-y>"] = require('telescope.actions').select_default,
			}
			,
			n = {
				["<C-f>"] = normalSwitch(require('telescope.builtin').find_files),
				["<C-g>g"] = normalSwitch(require('telescope.builtin').live_grep, grepExcludeVenvOpts),
				["<C-g><C-g>"] = normalSwitch(require('telescope.builtin').live_grep, grepExcludeVenvOpts),
				["<C-g>a"] = normalSwitch(require('telescope.builtin').live_grep, grepOpts),
				["<C-g><C-a>"] = normalSwitch(require('telescope.builtin').live_grep, grepOpts),
				["<C-k>"] = normalSwitch(require('telescope').extensions.recent_files.pick),
				["<C-h>"] = normalSwitch(require('telescope.builtin').find_files, dir_search_opts),
				["<C-y>"] = require('telescope.actions').select_default,
			},
		},
		cache_picker = {
			num_pickers = 50,
			limit_entries = 1000,
		},
		layout_strategy = "vertical",
		sorting_strategy = "ascending",
		layout_config = {
			prompt_position = "top",
		},
	},

	pickers = {
		find_files = {
			find_command = { "rg", "--files", "--hidden", "--no-ignore","--glob", "!**/.git/*", "--glob", "!**/__pycache__/*", "--glob", exludeVenv},
			layout_config = {
				preview_height = 0
			}
		},

		colorscheme = {
			enable_preview = true
		},

		registers = {
			mappings = {
				i = register_mappings_i,
				n = register_mappings_n,
			},
		},
	},
	extensions = {
		recent_files = {
			only_cwd = true,
			show_current_file = false,
			layout_config = {
				preview_height = 0
			}
		},
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		['ui-select'] = {
			require('telescope.themes').get_dropdown(),
		},
	}
})

telescope.load_extension("recent_files")
telescope.load_extension("fzf")
telescope.load_extension("ui-select")
telescope.load_extension("helpgrep")
telescope.load_extension("undo")

vim.keymap.set('n', '<leader>fH', ":Telescope helpgrep<CR>", { noremap = true, silent = true, desc = "Telescope help grep" })

vim.keymap.set('n', '<leader>fu', telescope.extensions.undo.undo , { noremap = true, silent = true, desc = "Telescope help grep" })

vim.keymap.set('n', '<leader>fC', function() builtin.colorscheme({ enable_preview = true }) end, { noremap = true, silent = true, desc = "Telescope colorscheme" })

vim.keymap.set('n', '<leader>fe', function() builtin.registers() end, { noremap = true, silent = true, desc = "Telescope registers" })

vim.api.nvim_set_keymap("n", "<leader>fk", [[<cmd>lua require('telescope').extensions.recent_files.pick()<CR>]], {noremap = true, silent = true})

-- Find files in the buffer current directory 
local themes = require('telescope.themes')
vim.keymap.set('n', '<leader>f.', function() builtin.find_files({ cwd = vim.fn.expand('%:p:h'), prompt_title=string.format("%s/", vim.fn.expand('%:h'))}) end)

-- Open last picker
vim.keymap.set('n', '<leader>fR', function() builtin.resume() end)

-- Select cached picker
vim.keymap.set('n', '<leader>fp', function() builtin.pickers() end)


vim.keymap.set('n', '<leader>fD', function() builtin.find_files(dir_search_opts) end)


vim.keymap.set('n', '<leader>fd', function() builtin.find_files(dir_local_search_opts()) end)

vim.keymap.set('n', '<leader>f/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })
