vim.g.mapleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- vim.keymap.set("n", "n", "nzzzv")
-- vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "n", "nzv")
vim.keymap.set("n", "N", "Nzv")
vim.keymap.set("t", "<C-n>", "<C-\\><C-n>")


vim.keymap.set("x", "$", "$h")


vim.keymap.set({"n", "x"}, "<leader>y", [["+y]])
vim.keymap.set({"n", "x"}, "<leader>Y", [["+Y]])

vim.keymap.set({"n", "x"}, "<leader>c", [["+c]])
vim.keymap.set({"n", "x"}, "<leader>C", [["+C]])

vim.keymap.set({"n", "x"}, "<leader>d", [["+d]])
vim.keymap.set({"n", "x"}, "<leader>D", [["+D]])

vim.keymap.set({"n", "x"}, "<leader>p", [["+p]])
vim.keymap.set({"n", "x"}, "<leader>P", [["+P]])


vim.keymap.set({"n", "x"}, "<A-D>", [["_D]])
vim.keymap.set({"n", "x"}, "<A-d>", [["_d]])
vim.keymap.set({"n"}, "<A-d><A-d>", [["_dd]])

vim.keymap.set({"n"}, "<A-c>", [["_c]])
vim.keymap.set({"n", "x"}, "<A-c><A-c>", [["_cc]])
vim.keymap.set({"n", "x"}, "<A-C>", [["_C]])


vim.keymap.set("x", "<M-p>", [["_dP]])

vim.keymap.set("x", "Y", "ygv")
vim.keymap.set("x", "<leader>Y", "<leader>ygv", { remap = true})

-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- vim.keymap.set("n", "<leader>bn", ":bnext<CR>")
-- vim.keymap.set("n", "<leader>bp", ":bprevious<CR>")

vim.keymap.set("n", "<M-j>", ":cnext<CR>")
vim.keymap.set("n", "<M-k>", ":cprev<CR>")
vim.keymap.set("n", "<leader>q", ":copen<CR>", { silent = true })
vim.keymap.set("n", "<leader>Q", ":cclose<CR>", { silent = true })

vim.keymap.set("n", "<C-w>e", ":vs #<CR>")

-- Quit all windows
vim.keymap.set("n", "<C-w>Q", ":qall<CR>")

-- "Zoom" in and out of split windows
vim.keymap.set("n", "<C-w>i", ":tab split<CR>", { silent = true, desc= "Zoom in" })
vim.keymap.set("n", "<C-w>I", ":tabclose<CR>", { silent = true, desc= "Zoom out" })
vim.keymap.set("n", "<C-w>z", ":tabclose<CR>", { silent = true, desc= "Zoom out alt" })

-- Mark remaps
-- vim.keymap.set("n", "<C-m>", "m", { noremap = true })
-- vim.keymap.set({"n", "o", "v"}, "m", "'", { noremap = true })
-- vim.keymap.set({"n", "o", "v"}, "<leader>m", "`", { noremap = true })

-- Fix Enter on normal mode due to mark remaps
-- vim.keymap.set("n", "<CR>", "<C-M>", { noremap = true })

-- Disable search highl ahting
vim.keymap.set("n", "<Esc>", ":noh<CR>", { silent = true , noremap = true})

-- Go to previous file (Alternate 2 last files)
vim.keymap.set("n", "<leader><leader>", ":e #<CR>", { silent = true })

vim.keymap.set("i", "<M-i>", "<Insert>", { silent = true })

vim.keymap.set({"n", "v"}, "<M-w>", ":set wrap!<CR>", { silent = true })

-- Fix quote text object around
vim.keymap.set({"o", "v"}, "a'", "2i'", { noremap = true, silent = true })

vim.keymap.set({"o", "v"}, "a\"", "2i\"", { noremap = true, silent = true })


-- Auto-save functionality
local function write_autosave_state(state)
	local f = io.open(vim.fn.stdpath("data") .. '/auto_save.txt', "w")
	if f then
		f:write(state and "1" or "0")
		f:close()
	else
		vim.notify("Failed to write autosave state")
	end
end

local function load_autosave_state()
	local state = io.open(vim.fn.stdpath("data") .. "/auto_save.txt", "r")
	if state then
		local file_content = state:read("*a")

		auto_save = file_content == "1"

		state:close()
	else
		write_autosave_state(false)
		auto_save = false
	end
	return auto_save
end


AUTO_SAVE = load_autosave_state()

local function is_file_buffer()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    return false
  end
  local stat = vim.uv.fs_stat(path)
  return stat and stat.type == "file"
end

local set_autosave_keymap = function()
	local remap = function()
		vim.cmd("stopinsert")
		if is_file_buffer() then
			vim.cmd("w")
		end
	end

	vim.keymap.set("i", "<Esc>", remap, { noremap = true })
end

-- Autocmd with conditional logic
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    if AUTO_SAVE and is_file_buffer() then
      vim.cmd("silent! write")
    end
  end,
})

if AUTO_SAVE then
	vim.notify("Auto-save enabled")
else
	vim.notify("Auto-save disabled")
end

local function toggle_auto_save()
	if AUTO_SAVE then
		vim.notify("Auto-save disabled")
	else 
		vim.notify("Auto-save enabled")
	end
	AUTO_SAVE = not AUTO_SAVE
	write_autosave_state(AUTO_SAVE)
end

vim.keymap.set("n", "<leader>a", toggle_auto_save, { noremap = true })

vim.api.nvim_create_autocmd("TextChanged", {
  pattern = "*.*",
  callback = function()
    if AUTO_SAVE and is_file_buffer() then
      vim.cmd("w")
    end
  end,
})


local statusAlt = [[%=%{expand("%:.")}%m %{(expand('#:p') !=# expand('%:p')) && (expand('#:p') != '') ? ' | #' . expand('#:t') : ''}%= ]]
local statusDefault = [[%=%{expand("%:.")}%m %=]]

vim.o.statusline = statusDefault
-- toggle between statusline with keymap
vim.keymap.set('n', '<leader>sl', function()
  if vim.o.statusline == statusAlt then
	vim.o.statusline = statusDefault
  else
	vim.o.statusline = statusAlt
  end
end, { desc = 'Toggle statusline' })
