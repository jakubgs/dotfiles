local map = vim.keymap.set

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- easier resizing
map("n", "<Up>", ":resize -5<CR>")
map("n", "<Down>", ":resize +5<CR>")
map("n", "<Left>", ":vert resize -5<CR>")
map("n", "<Right>", ":vert resize +5<CR>")

-- easier access to commands
map("n", ";", ":<C-F>")
map("n", ":", ";")
map("n", "q;", ":")
map("x", ";", ":<C-F>")
map("x", ":", ";")
map("x", "q;", ":")

-- reselect visual block after indent/outdent
map("x", "<", "<gv")
map("x", ">", ">gv")

-- search visually selected text
map("v", "*", [[y/\V<C-R>=escape(@",'/\')<CR><CR>]])

-- make last typed word uppercase
map("i", "<C-u>", "<Esc>viwUea")

-- for moving in wrapped lines
map("n", "j", "gj")
map("n", "k", "gk")
map("n", "gj", "j")
map("n", "gk", "k")

map("n", "K", "<Plug>NetrwBrowseX")
-- to match the behaviour of D
map("n", "Y", "y$")
-- run last used macro with one key
map("n", "Q", "@@")
-- for jumping forward
map("n", "<C-p>", "<C-i>")

-- easier navigation between splits
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- copy to clipboard with ctrl+c in visual mode
map("x", "<C-c>", [["*y:call system('xclip -i -selection clipboard', @*)<CR>]])

map("n", "<leader>p", function() _G.CopyPath(false) end)
map("n", "<leader>P", function() _G.CopyPath(true) end)

-- close buffer but leave active pane open
map("n", "<leader>q", ":bprevious<bar>bd! #<CR>", { silent = true })
map("n", "<leader>Q", ":<CR>", { silent = true })

-- Edit .vimrc and refresh configuration
map("n", "<leader>r", ":source ~/dotfiles/.config/nvim/init.lua<CR>")
map("n", "<leader>R", ":vsp ~/dotfiles/.config/nvim/init.lua<CR>")
map("n", "<leader>T", ":vsp ~/work/jakubgs-notes/todo.md<CR>")

-- Checkbox
map("n", "<leader>t", ":ToggleCB<CR>")
-- Terminal
map("n", "<leader>\\", ":Dispatch! urxvtc -cd %:p:h<CR>")
