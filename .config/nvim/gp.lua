vim.o.autoread = true

require("gp").setup({
  default_chat_agent = "gpt-5-nano",
  default_command_agent = "gpt-5-nano",
  agents = {
    {
      name = "gpt-5-nano",
      chat = true,
      command = true,
      model = { model = "gpt-5-nano-2025-08-07", verbosity = "low", effort = "low" },
      system_prompt = require("gp.defaults").code_system_prompt,
    },
  },
  chat_template = require("gp.defaults").short_chat_template,
  toggle_target = "vsplit",
})

local map = vim.keymap.set

map({ "n", "x" }, "<leader>oo", function() vim.cmd("GpChatToggle") end, { desc = "Toggle GP chat" })
map("x", "<leader>oc", ":<C-u>'<,'>GpChatPaste vsplit<cr>", { desc = "Send selection to GP chat" })
map("x", "<leader>oa", ":<C-u>'<,'>GpAppend<cr>", { desc = "Append GP response after selection" })
map("n", "<leader>oa", "<cmd>GpAppend<cr>", { desc = "Append GP response after line" })
map("n", "<leader>of", "<cmd>GpChatFinder<cr>", { desc = "Find GP chat" })
map("n", "<leader>ox", "<cmd>GpStop<cr>", { desc = "Stop GP" })
map("n", "<leader>os", "<cmd>GpSelectAgent<cr>", { desc = "Select GP agent" })
map("n", "<leader>oN", "<cmd>%GpVnew<cr>", { desc = "New chat with file context" })
map("n", "<leader>on", "<cmd>GpVnew<cr>", { desc = "New chat in vertical split" })
map("n", "<leader>oR", "<cmd>%GpRewrite<cr>", { desc = "Rewrite current file" })
map("n", "<leader>or", "<cmd>GpRewrite<cr>", { desc = "Rewrite current line" })
map("x", "<leader>or", ":<C-u>'<,'>GpRewrite<cr>", { desc = "Rewrite selected lines" })
map("n", "<leader>oC", "<cmd>%GpContext vsplit<cr>", { desc = "Provide file as custom context" })
map("x", "<leader>oC", ":<C-u>'<,'>GpContext vsplit<cr>", { desc = "Provide selection as custom context" })
