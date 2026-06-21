local map = vim.keymap.set

map("n", "<Up>", ":resize -5<CR>")
map("n", "<Down>", ":resize +5<CR>")
map("n", "<Left>", ":vert resize -5<CR>")
map("n", "<Right>", ":vert resize +5<CR>")

map("n", ";", ":<C-F>")
map("n", ":", ";")
map("n", "q;", ":")
map("x", ";", ":<C-F>")
map("x", ":", ";")
map("x", "q;", ":")

map("x", "<", "<gv")
map("x", ">", ">gv")

map("v", "*", [[y/\V<C-R>=escape(@",'/\')<CR><CR>]])

map("i", "<C-u>", "<Esc>viwUea")

map("n", "j", "gj")
map("n", "k", "gk")
map("n", "gj", "j")
map("n", "gk", "k")

map("n", "K", "<Plug>NetrwBrowseX")
map("n", "Y", "y$")
map("n", "Q", "@@")
map("n", "<C-p>", "<C-i>")

map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

map("x", "<C-c>", [["*y:call system('xclip -i -selection clipboard', @*)<CR>]])

map("n", "<leader>p", function() _G.CopyPath(false) end)
map("n", "<leader>P", function() _G.CopyPath(true) end)

map("n", "<leader>q", ":bprevious<bar>bd! #<CR>", { silent = true })
map("n", "<leader>Q", ":<CR>", { silent = true })

map("n", "<leader>r", ":source ~/dotfiles/.config/nvim/init.lua<CR>")
map("n", "<leader>R", ":vsp ~/dotfiles/.config/nvim/init.lua<CR>")
map("n", "<leader>T", ":vsp ~/work/jakubgs-notes/todo.md<CR>")

map("n", "<leader>t", ":ToggleCB<CR>")
map("n", "<leader>\\", ":Dispatch! urxvtc -cd %:p:h<CR>")
map("n", "<F10>", ":Goyo<CR>")

vim.g.goyo_width = 120
