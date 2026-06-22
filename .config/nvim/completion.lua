-- Deoplete
vim.opt.completeopt = { "menu", "preview" }

vim.g["deoplete#sources#go#gocode_binary"] = "/home/sochan/.nix-profile/bin/gocode"
vim.g["deoplete#sources#go#gopls_binary"] = "/home/sochan/.nix-profile/bin/gopls"
vim.g["deoplete#sources#ternjs#tern_bin"] = "/usr/local/bin/tern"
vim.g["deoplete#sources#ternjs#timeout"] = 1
vim.g["deoplete#sources#ternjs#docs"] = 1
vim.g["deoplete#enable_at_startup"] = 1

local function check_back_space()
  local col = vim.fn.col(".") - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

vim.fn["deoplete#custom#option"]({
  auto_complete_delay = 0,
  smart_case = true,
})

vim.keymap.set("i", "<Tab>", function()
  if vim.fn.pumvisible() == 1 then
    return "\014"
  end
  if check_back_space() then
    return "\009"
  end
  return vim.fn["deoplete#manual_complete"]()
end, { expr = true, silent = true })
