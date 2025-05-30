resize_mode = require("resize-mode")
resize_mode.setup {
  horizontal_amount = 9,
  vertical_amount = 5,
  quit_key = "<ESC>",
  enable_mapping = true,
  resize_keys = {
      "h", -- increase to the left
      "j", -- increase to the bottom
      "k", -- increase to the top
      "l", -- increase to the right
      "H", -- decrease to the left
      "J", -- decrease to the bottom
      "K", -- decrease to the top
      "L"  -- decrease to the right
  },
  hooks = {
    on_enter = function()vim.notify("Resize Mode")end, -- called when entering resize mode
    on_leave = function()vim.notify("")end,  -- called when leaving resize mode
  }
}

vim.keymap.set("n", "<M-r>", resize_mode.start, { desc = "Enter resize mode"})
