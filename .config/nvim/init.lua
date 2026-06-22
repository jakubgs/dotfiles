-- Author: Jakub Sokołowski <jakub@gsokolowski.pl>
-- Source: https://github.com/jakubgs/dotfiles

-- Syntax highlighting is slow for big files.
local fsize = vim.fn.getfsize(vim.fn.expand("%"))
vim.cmd("syntax " .. (fsize > 50000 and "off" or "on"))

-- Define leader early to affect loaded plugins.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local config = vim.fn.stdpath("config")
for _, file in ipairs({
  "plugins.lua",
  "theme.lua",
  "general.lua",
  "terminal.lua",
  "functions.lua",
  "mappings.lua",
  "search.lua",
  "completion.lua",
  "cmdwin.lua",
  "git.lua",
}) do
  dofile(config .. "/" .. file)
end
