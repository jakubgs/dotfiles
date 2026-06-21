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
  "tpope/vim-dispatch",
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
    opts = {},
  },
  {
    "robitx/gp.nvim",
    config = function()
      dofile(vim.fn.stdpath("config") .. "/gp.lua")
    end,
  },
  "xolox/vim-misc",
  "junegunn/goyo.vim",
  "junegunn/vim-peekaboo",
  "bogado/file-line",
  "akinsho/toggleterm.nvim",
  { "tyjak/vim-redact-pass", commit = "403a44dc" },

  "tpope/vim-surround",
  "tpope/vim-repeat",
  "jkramer/vim-checkbox",
  "ntpeters/vim-better-whitespace",

  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",

  {
    "junegunn/fzf",
    build = function()
      vim.fn["fzf#install"]()
    end,
  },
  "junegunn/fzf.vim",
  "benwainwright/fzf-project",

  "justinmk/vim-sneak",

  "Shougo/deoplete.nvim",
  "Shougo/neco-vim",
  { "deoplete-plugins/deoplete-go", build = "make" },
  { "carlitux/deoplete-ternjs", build = "yarn global add tern" },
  "deoplete-plugins/deoplete-jedi",

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
