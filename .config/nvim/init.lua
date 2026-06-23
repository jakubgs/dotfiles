-- Author: Jakub Sokołowski <jakub@gsokolowski.pl>
-- Source: https://github.com/jakubgs/dotfiles

-- Syntax highlighting is slow for big files.
local fsize = vim.fn.getfsize(vim.fn.expand("%"))
vim.cmd("syntax " .. (fsize > 50000 and "off" or "on"))

local config = vim.fn.stdpath("config")
for _, file in ipairs({
  "general.lua",
  "commands.lua",
  "functions.lua",
  "mappings.lua",
  "plugins.lua",
  "theme.lua",
  "terminal.lua",
  "search.lua",
  "completion.lua",
  "cmdwin.lua",
  "git.lua",
}) do
  dofile(config .. "/" .. file)
end
