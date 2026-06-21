vim.cmd("syntax on")
vim.cmd("filetype on")
vim.cmd("filetype plugin on")
vim.cmd("filetype indent on")

vim.opt.autochdir = true
vim.opt.splitright = true
vim.opt.clipboard = "unnamedplus"
vim.opt.hidden = true

vim.opt.list = true
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showmatch = true
vim.opt.scrolloff = 3
vim.opt.foldenable = false
vim.opt.wrap = false

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.iskeyword:append({ "$", "@", "%" })
vim.opt.iskeyword:remove({ "_", "." })

vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.config/nvim/undo//")
vim.opt.undolevels = 100
vim.opt.undoreload = 1000

if vim.fn.has("multi_byte") == 1 then
  vim.opt.fillchars = { vert = "│", fold = "-" }
  vim.opt.listchars = { tab = "▸ ", eol = "¬" }
end

vim.g.netrw_liststyle = 4

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

local autoresize = vim.api.nvim_create_augroup("autoresize", { clear = true })
vim.api.nvim_create_autocmd("VimResized", {
  group = autoresize,
  pattern = "*",
  command = [[silent! exe "normal! \<c-w>=" ]],
})

vim.api.nvim_create_user_command("Sw", function()
  vim.cmd([[silent exe 'write !sudo tee % >/dev/null' | silent edit!]])
end, { bar = true })
