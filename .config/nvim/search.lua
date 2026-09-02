local map = vim.keymap.set
local fzf = require("fzf-lua")
local actions = require("fzf-lua.actions")

-- FZF
vim.g.fzf_history_dir = "~/.local/share/fzf-history"
fzf.setup({
  winopts = {
    split = "enew",
    preview = {
      hidden = true,
      horizontal = "right:50%",
      layout = "horizontal",
    },
  },
  fzf_opts = {
    ["--layout"] = "reverse",
    ["--bind"] = "ctrl-k:up,ctrl-j:down",
  },
  files = {
    cmd = 'ag --hidden -g ""',
  },
})

-- fix for line numbers in FZF window
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  command = "setlocal nonumber norelativenumber",
})

-- Helper to avoid path issues and start in input mode.
local function work_sink(line)
  fzf.files({ cwd = vim.fn.expand("~/work/" .. line) })
end

-- Search ~/work directory
local function work_search()
  fzf.fzf_exec("ls -1", {
    cwd = vim.fn.expand("~/work"),
    actions = {
      ["enter"] = function(selected)
        if selected[1] then work_sink(selected[1]) end
      end,
    },
  })
end

-- Search work dir or current git files.
local function panacea_func()
  if vim.fn.empty(_G.GetGitRoot()) == 1 then
    work_search()
  else
    fzf.git_files()
  end
end

-- Search with Ag but from repo root.
function _G.GitRootAg(input)
  local root = _G.GetGitRoot()
  if root == "" then return end
  fzf.grep({
    cwd = root,
    search = input or "",
    winopts = { fullscreen = true },
  })
end

local function git_unstaged()
  fzf.fzf_exec("git ls-files --others --modified --exclude-standard", {
    actions = { ["enter"] = actions.file_edit },
  })
end

local function undo_tree()
  fzf.undotree({
    previewer = "undotree",
    winopts = {
      split = false,
      preview = {
        hidden = false,
        layout = "horizontal",
        horizontal = "right:50%",
      },
    },
  })
end

vim.api.nvim_create_user_command("Work", work_search, {})
vim.api.nvim_create_user_command("Panacea", panacea_func, {})
vim.api.nvim_create_user_command("GitUnstaged", git_unstaged, {})
vim.api.nvim_create_user_command("UndoTree", undo_tree, {})
vim.api.nvim_create_user_command("GitRootAg", function(opts)
  _G.GitRootAg(opts.args)
end, { nargs = "?" })
vim.api.nvim_create_user_command("AG", function(opts)
  _G.GitRootAg(opts.args)
end, { nargs = "?" })

vim.api.nvim_create_user_command("Ag", function(opts)
  fzf.grep({
    search = opts.args,
    winopts = { fullscreen = opts.bang },
  })
end, { nargs = "*", bang = true })

map("n", "<Tab>", panacea_func)
map("n", "<C-a>", work_search)
map("n", "<C-s>", function() fzf.files({ cwd = "~/nixos" }) end)
map("n", "<C-q>", function() fzf.files({ cwd = "~/dotfiles" }) end)
map("n", "<C-Space>", fzf.history)
map("n", "<C-b>", fzf.buffers)
map("n", "<leader><leader>a", function() _G.GitRootAg("") end)
map("n", "<leader><leader>b", fzf.buffers)
map("n", "<leader><leader>c", fzf.git_commits)
map("n", "<leader><leader>f", fzf.files)
map("n", "<leader><leader>g", fzf.git_files)
map("n", "<leader><leader>h", fzf.history)
map("n", "<leader><leader>l", fzf.blines)
map("n", "<leader><leader>L", fzf.lines)
map("n", "<leader><leader>m", fzf.marks)
map("n", "<leader><leader>s", function() _G.GitRootAg(vim.fn.expand("<cword>")) end)
map("n", "<leader><leader>u", ":UndoTree<CR>")
map("n", "<leader><leader>U", ":GitUnstaged<CR>")
map("n", "<leader><leader>A", ":GitRootAg<Space>")
