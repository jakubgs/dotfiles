-- Return to last edit position when opening files.
local saveposition = vim.api.nvim_create_augroup("saveposition", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
  group = saveposition,
  pattern = "*",
  callback = function()
    local mark = vim.fn.line("'\"")
    if mark > 0 and mark <= vim.fn.line("$") then
      vim.cmd([[normal! g`"]])
    end
  end,
})

-- Auto resize splits when vim window size changes.
local autoresize = vim.api.nvim_create_augroup("autoresize", { clear = true })
vim.api.nvim_create_autocmd("VimResized", {
  group = autoresize,
  pattern = "*",
  command = [[silent! exe "normal! \<c-w>=" ]],
})

-- save the file as root (tee must be addedd as NOPASSWD to sudoers)
vim.api.nvim_create_user_command("Sw", function()
  vim.cmd([[silent exe 'write !sudo tee % >/dev/null' | silent edit!]])
end, { bar = true })
