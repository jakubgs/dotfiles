local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop
if not uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  -- misc
  "tpope/vim-dispatch",
  { "stevearc/oil.nvim", cmd = "Oil", keys = { { "-", "<cmd>Oil<cr>", desc = "Open parent directory" }, }, opts = {}, },
  "xolox/vim-misc",
  { "junegunn/goyo.vim", keys = { { "<F10>", "<Cmd>Goyo<CR>", mode = "n", desc = "Open Goyo" }, }, init = function() vim.g.goyo_width = 120 end, },
  "junegunn/vim-peekaboo",
  "bogado/file-line",
  "akinsho/toggleterm.nvim",
  { "tyjak/vim-redact-pass", commit = "403a44dc" },
  -- text manipulation
  "tpope/vim-surround",
  "tpope/vim-repeat",
  "jkramer/vim-checkbox",
  "ntpeters/vim-better-whitespace",
  -- git
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
  -- search
  "junegunn/fzf",
  "junegunn/fzf.vim",
  "benwainwright/fzf-project",
  -- movement
  "justinmk/vim-sneak",
  -- completion
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  { "robitx/gp.nvim", config = function() dofile(vim.fn.stdpath("config") .. "/gp.lua") end, },
  -- style
  "nanotech/jellybeans.vim",
  "itchyny/lightline.vim",
}

vim.list_extend(plugins, dofile(vim.fn.stdpath("config") .. "/syntax.lua"))

require("lazy").setup(plugins, {
  root = vim.fn.stdpath("data") .. "/lazy",
  lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
  install = {
    colorscheme = { "jellybeans" },
  },
  checker = {
    enabled = false,
  },
})
