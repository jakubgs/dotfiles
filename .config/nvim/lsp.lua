vim.diagnostic.config({
  -- Show LSP warnings inside of the buffer.
  virtual_text = true,
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("nil_ls", {
  capabilities = capabilities,
})

vim.lsp.enable("nil_ls")
