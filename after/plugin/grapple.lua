function GrappleTag(move_to)
	local grapple = require("grapple")
	local i = 1
	local grapple_tag = grapple.find({index = i})
	local exists = false
	while grapple_tag do
		if grapple_tag.path == vim.fn.expand("%:p") and not move_to then
			exists = true
			break
		end
		i = i + 1
		grapple_tag = grapple.find({index = i})
	end

	if not move_to then
		index = i
	else
		index = math.min(move_to, i-1) or i
	end
	grapple.tag({index = index})


	local notifyStr = "Grapple: Tagged current file on index %d"
	if exists then
		notifyStr = "Grapple: File is already tagged on index %d"
	end
	vim.notify(string.format(notifyStr, index), vim.log.levels.INFO)

end

function GrappleUntag()
	require("grapple").untag()
	vim.notify("Grapple: Untagged current file", vim.log.levels.INFO)
end

vim.keymap.set("n", "<leader>ga", GrappleTag, { desc = "Grapple tag" })
vim.keymap.set("n", "<leader>gd", GrappleUntag, { desc = "Grapple untag" })
vim.keymap.set("n", "<leader>gt", require("grapple").toggle_tags)

-- User commands
vim.keymap.set("n", "<M-1>", "<cmd>Grapple select index=1<cr>")
vim.keymap.set("n", "<M-2>", "<cmd>Grapple select index=2<cr>")
vim.keymap.set("n", "<M-3>", "<cmd>Grapple select index=3<cr>")
vim.keymap.set("n", "<M-4>", "<cmd>Grapple select index=4<cr>")
vim.keymap.set("n", "<M-5>", "<cmd>Grapple select index=5<cr>")
vim.keymap.set("n", "<M-6>", "<cmd>Grapple select index=6<cr>")


vim.keymap.set("n", "<leader>1", "<cmd>Grapple select index=1<cr>")
vim.keymap.set("n", "<leader>2", "<cmd>Grapple select index=2<cr>")
vim.keymap.set("n", "<leader>3", "<cmd>Grapple select index=3<cr>")
vim.keymap.set("n", "<leader>4", "<cmd>Grapple select index=4<cr>")
vim.keymap.set("n", "<leader>5", "<cmd>Grapple select index=5<cr>")
vim.keymap.set("n", "<leader>6", "<cmd>Grapple select index=6<cr>")



vim.keymap.set("n", "<leader>gsa", function() GrappleTag(1) end)
vim.keymap.set("n", "<leader>gss", function() GrappleTag(2) end)
vim.keymap.set("n", "<leader>gsd", function() GrappleTag(3) end)
vim.keymap.set("n", "<leader>gsf", function() GrappleTag(4) end)
vim.keymap.set("n", "<leader>gsg", function() GrappleTag(5) end)
vim.keymap.set("n", "<leader>gsh", function() GrappleTag(6) end)


vim.keymap.set("n", "<leader>gs1", function() GrappleTag(1) end)
vim.keymap.set("n", "<leader>gs2", function() GrappleTag(2) end)
vim.keymap.set("n", "<leader>gs3", function() GrappleTag(3) end)
vim.keymap.set("n", "<leader>gs4", function() GrappleTag(4) end)
vim.keymap.set("n", "<leader>gs5", function() GrappleTag(5) end)
vim.keymap.set("n", "<leader>gs6", function() GrappleTag(6) end)


