local function init_cmdwin()
  pcall(vim.keymap.del, "i", "<Tab>", { buffer = true })
  pcall(vim.keymap.del, "n", "<Tab>", { buffer = true })

  vim.keymap.set("n", "q", ":<C-u>quit<CR>", { buffer = true, silent = true })
  vim.keymap.set("n", "<Tab>", ":<C-u>quit<CR>", { buffer = true, silent = true })

  vim.keymap.set("i", "<C-j>", function()
    return vim.fn.pumvisible() == 1 and "\014" or "\010"
  end, { buffer = true, expr = true, silent = true })
  vim.keymap.set("i", "<C-k>", function()
    return vim.fn.pumvisible() == 1 and "\016" or "\011"
  end, { buffer = true, expr = true, silent = true })
  vim.keymap.set("i", "<Tab>", function()
    return vim.fn.pumvisible() == 1 and "\025" or "\009"
  end, { buffer = true, expr = true, silent = true })
  vim.keymap.set("i", "<CR>", function()
    return vim.fn.pumvisible() == 1 and "\005\013" or "\013"
  end, { buffer = true, expr = true, silent = true })

  vim.cmd.startinsert({ bang = true })
end

local group = vim.api.nvim_create_augroup("MyAutoCmd", { clear = true })
vim.api.nvim_create_autocmd("CmdwinEnter", {
  group = group,
  pattern = "*",
  callback = function()
    pcall(init_cmdwin)
  end,
})
