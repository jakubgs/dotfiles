" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif
call plug#begin('~/.config/nvim/bundle')

" Misc plugins
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-vinegar'
Plug 'xolox/vim-misc'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'bogado/file-line'
Plug 'akinsho/toggleterm.nvim'
" Text manipulation
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'jkramer/vim-checkbox'
" Git plugins
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'junegunn/gv.vim'
" Searching Plugins
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'benwainwright/fzf-project'
" Movement
Plug 'justinmk/vim-sneak'
Plug 'chrisgrieser/nvim-spider'
" Completion
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/neco-vim'
Plug 'deoplete-plugins/deoplete-go', { 'do': 'make'}
Plug 'carlitux/deoplete-ternjs', { 'do': 'yarn global add tern' }
Plug 'deoplete-plugins/deoplete-jedi'
" Style
Plug 'nanotech/jellybeans.vim'
Plug 'itchyny/lightline.vim'

source ~/.config/nvim/syntax.vim

call plug#end()
