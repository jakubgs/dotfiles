vim.cmd("syntax on")              -- File-type highlighting
vim.cmd("filetype on")            -- enable file type detection
vim.cmd("filetype plugin on")     -- loading of plugin files for all formats
vim.cmd("filetype indent on")     -- loading of indent files for all formats

-- Buffers
vim.opt.autochdir = true          -- Automatically changing working dir
vim.opt.splitright = true         -- new windows right to the current
vim.opt.clipboard = "unnamedplus" -- paste the clipboard to unnamed register
vim.opt.hidden = true             -- buffer change, more undo
vim.opt.shortmess:append("I")     -- Disable default splash screen

-- Visual
vim.opt.list = true               -- show tabs and newlines
vim.opt.cursorline = true         -- highlight the current line
vim.opt.number = true             -- show current line number
vim.opt.relativenumber = true     -- distance from the current line
vim.opt.showmatch = true          -- show matching brackets
vim.opt.scrolloff = 3             -- number of lies vim won't scroll below
vim.opt.foldenable = false        -- disable folding by default
vim.opt.wrap = false              -- text wrapping

-- Formatting
vim.opt.expandtab = true          -- use spaces instead of tabs
vim.opt.tabstop = 4               -- spaces in <tab>
vim.opt.softtabstop = 4           -- spaces in <tab> when editing
vim.opt.shiftwidth = 4            -- spaces for each step of (auto)indent

-- Search
vim.opt.ignorecase = true         -- ignore case
vim.opt.smartcase = true          -- unless upper case used
vim.opt.iskeyword:append({"$","@","%"})
vim.opt.iskeyword:remove({"_","."})

-- Saves lives
vim.opt.undofile = true           -- save undos after file closes
vim.opt.undodir = vim.fn.expand("~/.config/nvim/undo//")
vim.opt.undolevels = 100          -- how many undos saved
vim.opt.undoreload = 1000         -- number of lines to save for undo

-- Visible chars for tabs and EOLs
if vim.fn.has("multi_byte") == 1 then
  vim.opt.listchars = { tab = "▸ ", eol = "¬" }
end
