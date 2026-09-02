local map = vim.keymap.set

-- Sneak
vim.g["sneak#label"] = 1
vim.g["sneak#target_labels"] = "abcdefghijklmnopqrstuvwxyz"
vim.g["sneak#s_next"] = 1
vim.g["sneak#use_ic_scs"] = 1
vim.g["sneak#prompt"] = "STREAK>>>"

map("n", "<Space>j", "<Plug>Sneak_s")
map("n", "<Space>k", "<Plug>Sneak_S")
map("n", "<C-f>", "<Plug>Sneak_s")
map("n", "s", "<Plug>Sneak_s")
map("n", "S", "<Plug>Sneak_S")
map({ "n", "v", "o" }, "f", "<Plug>Sneak_f")
map({ "n", "v", "o" }, "F", "<Plug>Sneak_F")
map({ "n", "v", "o" }, "t", "<Plug>Sneak_t")
map({ "n", "v", "o" }, "T", "<Plug>Sneak_T")
