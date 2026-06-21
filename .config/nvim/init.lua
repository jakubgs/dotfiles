-- Author: Jakub Sokołowski <jakub@gsokolowski.pl>
-- Source: https://github.com/jakubgs/dotfiles

if vim.fn.getfsize(vim.fn.expand("%")) > 50000 then
  vim.cmd("syntax off")
else
  vim.cmd("syntax on")
end

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
