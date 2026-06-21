vim.g.jellybeans_overrides = {
  background = { ctermbg = "NONE", ["256ctermbg"] = "NONE", guibg = "NONE" },
}

vim.opt.background = "dark"
vim.cmd.colorscheme("jellybeans")

vim.cmd("hi! link Visual LightlineLeft_visual_0")
vim.cmd("hi! link Cursor LightlineLeft_normal_0")

vim.cmd("hi! link Sneak Cursor")
vim.cmd("hi! link SneakLabel TabLineSel")

vim.cmd("hi ExtraWhitespace ctermbg=darkred guibg=darkred")
vim.g.better_whitespace_enabled = 1
vim.g.strip_whitelines_at_eof = 1
vim.g.strip_whitespace_on_save = 1
vim.g.strip_whitespace_confirm = 0
