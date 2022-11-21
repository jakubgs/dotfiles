" Author: Jakub Sokołowski <jakub@gsokolowski.pl>
" Source: https://github.com/jakubgs/dotfiles

" Syntax highlighting is slow for big files.
if getfsize(expand('%')) > 50000
    syntax off
else
    syntax on
endif

source ~/.config/nvim/plugins.vim
source ~/.config/nvim/theme.vim
source ~/.config/nvim/general.vim
source ~/.config/nvim/functions.vim
source ~/.config/nvim/mappings.vim
source ~/.config/nvim/search.vim
source ~/.config/nvim/completion.vim
source ~/.config/nvim/cmdwin.vim
source ~/.config/nvim/git.vim
