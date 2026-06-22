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

-- FZF
vim.g.fzf_layout = { window = "enew" }
vim.g.fzf_preview_window = { "right:50%:hidden", "ctrl-p" }
vim.g.fzf_history_dir = "~/.local/share/fzf-history"
vim.env.FZF_DEFAULT_COMMAND = 'ag --hidden -g ""'
vim.env.FZF_DEFAULT_OPTS = "--reverse --bind ctrl-k:up,ctrl-j:down"

-- fix for line numbers in FZF window
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  command = "setlocal nonumber norelativenumber",
})

-- Helper to avoid path issues and start in input mode.
local function work_sink(line)
  vim.cmd("Files ~/work/" .. line)
end

local function work_search()
  vim.fn["fzf#run"](vim.fn["fzf#wrap"]({
    source = "ls ~/work",
    dir = "~/work",
    sink = work_sink,
  }))
end

local function panacea_func()
  if vim.fn.empty(_G.GetGitRoot()) == 1 then
    work_search()
  else
    vim.fn["fzf#vim#gitfiles"]("")
  end
end

-- Search with Ag but from repo root.
function _G.GitRootAg(input)
  vim.cmd("cd " .. _G.GetGitRoot())
  vim.cmd("Ag! " .. input)
end

local function git_unstaged()
  vim.fn["fzf#run"](vim.fn["fzf#wrap"]({
    source = "git ls-files --others --modified --exclude-standard",
  }))
end

vim.api.nvim_create_user_command("Work", work_search, {})
vim.api.nvim_create_user_command("Panacea", panacea_func, {})
vim.api.nvim_create_user_command("GitUnstaged", git_unstaged, {})
vim.api.nvim_create_user_command("GitRootAg", function(opts)
  _G.GitRootAg(opts.args)
end, { nargs = "?" })
vim.api.nvim_create_user_command("AG", function(opts)
  _G.GitRootAg(opts.args)
end, { nargs = "?" })

vim.cmd([[
command! -bang -nargs=? -complete=dir Ag
  \ call fzf#vim#ag(<q-args>, fzf#vim#with_preview('right'), <bang>0)
]])

map("n", "<Tab>", ":Panacea<CR>")
map("n", "<C-a>", ":Work<CR>")
map("n", "<C-s>", ":Files ~/nixos<CR>")
map("n", "<C-q>", ":Files ~/dotfiles<CR>")
map("n", "<C-Space>", ":History<CR>")
map("n", "<C-b>", ":Buffers<CR>")
map("n", "<leader><leader>b", ":Buffers<CR>")
map("n", "<leader><leader>h", ":History<CR>")
map("n", "<leader><leader>m", ":Marks<CR>")
map("n", "<leader><leader>f", ":Files<CR>")
map("n", "<leader><leader>g", ":GFiles<CR>")
map("n", "<leader><leader>u", ":GitUnstaged<CR>")
map("n", "<leader><leader>c", ":Commits<CR>")
map("n", "<leader><leader>l", ":Lines<CR>")
map("n", "<leader><leader>a", ":GitRootAg<CR>")
map("n", "<leader><leader>A", ":GitRootAg<Space>")
map("n", "<leader><leader>s", [[:GitRootAg<Space><C-R>=expand("<cword>")<CR><CR>]])
