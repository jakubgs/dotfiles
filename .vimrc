" VIM instad of VI
set nocompatible

" {{{ Vundle plugin management
filetype off " required!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
" powerline statusline
set rtp+=~/.powerline/powerline/bindings/vim/

" let Vundle manage Vundle
Bundle 'gmarik/vundle'
" original repos on github
Bundle 'Lokaltog/vim-easymotion'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-dispatch'
Bundle 'tpope/vim-surround'
Bundle 'ervandew/supertab'
Bundle 'majutsushi/tagbar'
Bundle 'fholgado/minibufexpl.vim'
Bundle 'Raimondi/delimitMate'
Bundle 'kien/ctrlp.vim'
Bundle 'scrooloose/syntastic'
Bundle 'PProvost/vim-ps1'
Bundle 'Valloric/MatchTagAlways'
Bundle 'szw/vim-tags'
" Colorschemes
Bundle 'nanotech/jellybeans.vim'

" }}}

" {{{ General configuration
set background=dark

if &t_Co == 256 || has('gui_running')
    colors jellybeans
else
    colors jellybeans " Or some other 16-color scheme
endif

" graphical font
if has("gui_running")
    if has("gui_gtk2")
        set guifont=Terminus\ 10
    elseif has("gui_win32")
        set guifont=Dina:h10:cANSI
    endif
endif

" File-type highlighting
syntax on
filetype on
filetype plugin on
filetype indent on

" encoding
set encoding=utf-8
set fileencoding=utf-8

" fix slight delay after pressing ESC then O
" " set noesckeys
set timeout timeoutlen=1000 ttimeoutlen=100

" minimum window size
set winwidth=75
set winheight=20

" set title when run in terminal
set title

" always show the statusline
set laststatus=2

" prevent some security exploits
set modelines=0

" faster macros processing
set lazyredraw

" tell vim to shut up set noerrorbells
set noerrorbells
set visualbell
set t_vb=

" Enable the use of the mouse.
set mouse=a

" Show normal line numbers
"set number
" Show how far each line of from the current one
set relativenumber

" number of lines you want to see in front of and after the cursor
" in this case we want it in the middle, hence the arbitrary high number
set scrolloff=5

" Show (partial) command in status line.
"set showcmd
set showmode
" When a bracket is inserted, briefly jump to the matching one
set showmatch

" folding
"set foldenable
set foldlevel=5
"set foldlevelstart=1
"set foldmethod=indent
"set foldmethod=marker
set foldmethod=syntax
set foldnestmax=2

" Number line width
set nuw=5

" automatically update file changes done by other programs
set autoread

" Indentation settings, autoindent breaks pasted in text
set autoindent
set preserveindent
"set copyindent

" paste the clipboard to unnamed register
set clipboard=unnamed

" spelling check
set spelllang=pl,en

" Automatically changing working dir
"set autochdir

" File menu
set wildmenu
" ignore case when opening files
set wildignorecase
set wildmode=list:full
set wildignore=.so,swp,.zip,.mp3,
                \.bak,.pyc,.o,.ojb,.,a,
                \ojb.pdf,.jpg,.gif,.png,
                \.avi,.mkv,.so,.out

" Shell
set shell=zsh

" remove message at vim start
set shortmess=atI

" command line length
set cmdheight=1

" Different compiler depending on type of file
set makeprg=make\ clean\ &&\ make\ -j4\ --silent
au FileType cpp set makeprg=/usr/bin/g++\ \-g\ \-Wall\ \-pedantic\ \"%\"\ -o\ \"%<.out\"
au FileType c set cindent
" Format for error QuickList
au FileType java set errorformat=%A%f:%l:\ %m,%-Z%p^,%C\ \ :\ %m,%-C%.%#
au FileType cpp set errorformat=%f:%l:%c:\ %m
" HTML
au FileType html,xml,xsl source ~/.vim/bundle/closetag.vim/plugin/closetag.vim

" Real men use gcc
compiler gcc

" make ~ files in:
set   backupdir=~/.vim/backup/

" disable swap
set noswapfile
"set   directory=~/.vim/temp/

" persistend undo history
if has('persistent_undo')
  set undofile                " Save undo's after file closes
  set undodir=~/.vim/undo " where to save undo histories
  set undolevels=100         " How many undos
  set undoreload=1000        " number of lines to save for undo
endif

" Tab width
set softtabstop=4
set shiftwidth=4
set tabstop=4
set cinoptions=>4

" use spaces instead of tabs
set expandtab
set smarttab

" make sure splits are at least 30 characters wide

" Get rid of useless GUI elements
set guioptions=

" Text wrappingi
set wrap
" don't break in middle of words
set linebreak

" Case insensitive search
set is
set ic
" highlighting search results
set hlsearch
" start searching as you type
set incsearch
set ignorecase
set smartcase

" not word dividers
set iskeyword+=_,$,@,%,#

" buffer change, more undo
set hidden

" Show matching brackets
set showmatch

" Faster standard output
set ttyfast

" Show columns and rows
set ruler

" highlight the current line
set cursorline

" }}}
"
" {{{ Plugin configuration
"
" Don't make comments italic
let g:jellybeans_overrides = {
\   'Comment': { 'cterm': 'italic' },
\   'Todo':     { 'guibg': 'ff0000', 'cterm': '224' },
\}

highlight Normal ctermbg=NONE " use terminal background
highlight nonText ctermbg=NONE " use terminal background
let g:jellybeans_use_lowcolor_black = 0

" Startify
let g:startify_unlisted_buffer = 0

" DelimitMate
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1
let delimitMate_smart_quotes = 0

" MiniBufExplorer
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplModSelTarget = 1
" so only one is open when using ctrlp
let g:miniBufExplorerMoreThanOne = 4

" SuperTab
let g:SuperTabDefaultCompletionType = "context"

" Powerline
let g:Powerline_symbols = 'compatible'

" TagBar
set tags=./tags;/
let g:tagbar_left = 1
let g:tagbar_width = 30
let g:tagbar_ctags_bin="/usr/bin/ctags"

" Stop CtrlP from recalculating on files on start
let g:ctrlp_cache_dir = $HOME.'/.vim/temp/ctrlp'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_show_hidden = 1
let g:ctrlp_working_path_mode = 'raw'
let g:ctrlp_root_markers = ['.root', 'Makefile', '.git' ]
let g:ctrlp_custom_ignore = {
	\ 'dir':  '\v[\/]\.(git|hg|svn)$',
	\ 'file': '\v\.(exe|so|dll|tmp|temp|swp|o)$',
	\ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
	\ }

" EasyMotion leader
let g:EasyMotion_leader_key = '<Space>'

" Changing leader to space
let mapleader = "\<Space>"
" don't let space do anything else
nnoremap <SPACE> <Nop>

" Toggle pastemode, doesn't indent
set pastetoggle=<F8>

" }}}

" save the file as root (tee must be addedd as NOPASSWD to sudoers)
"map :suw :w !sudo tee % > /dev/null
command! -bar -nargs=0 Sw :silent exe 'write !sudo tee % >/dev/null' | silent edit!

" compile
map mm :echohl WildMenu<cr>:echon "Compiling file..."<cr>:silent! Make<cr>:bot copen 6<cr><C-w><Up>:echohl None<cr>:echo ""<cr><c-l>

" {{{ Key Mappings

" For closing tags in HTML
iabbrev </ </<C-X><C-O><Backspace>

" vertical help
cnoremap help rightb vert help

" Fast saving
nmap <c-s> :w!<cr>

"" Learn to use hjkl
nnoremap <up> ddkP
nnoremap <down> ddp
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" paste with ctrl+v from clipboard in insert mode
inoremap <c-v> <c-r>+
nnoremap <c-v> "+p
" paste to clipboard with ctrl+c in visual mode
vnoremap <c-c> "+y

" remove annoying comman-line window
nnoremap q: :q

" for moving in wrapped lines
nnoremap j gj
nnoremap k gk

" search results in the centre of the screen
nmap n nzz
nmap N Nzz

" fugitive git bindings
nnoremap ga :Git add %<CR><CR>
nnoremap gs :Gstatus<CR>
nnoremap gc :Gcommit<CR>i
nnoremap gd :Gdiff<CR>
nnoremap ge :Gedit<CR>
nnoremap gr :Gread<CR>
nnoremap gw :Gwrite<CR><CR>
nnoremap gl :Glog<CR>
nnoremap gm :Gmove 
nnoremap gb :Git branch 
nnoremap gco :Git checkout
nnoremap gps :Dispatch git push<CR>
nnoremap gpl :Dispatch git pull<CR>

" paste and sellect
nnoremap <leader>p p`[v`]
nnoremap <leader>P P`[v`]

" append a semicolon
nnoremap <leader>; A;<Esc>

" strip all trailing whitespaces in current file
nnoremap <leader>r :%s/\s\+$//<cr>:let @/=''<CR>;

" Window management
" split vertical and switch
nnoremap <leader>s <C-w>v<C-w>l
" split horizontal and switch
nnoremap <leader>d <C-w>s<C-w>l
" close buffer but leave active pane open
nnoremap <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>

" Edit .vimrc and erfresh configuration
nnoremap <leader>V :vsp ~/.vimrc<CR>
nnoremap <leader>v :source ~/.vimrc<CR>

" CtrlP mappings
nnoremap <Tab>      :CtrlPMixed<CR>
nnoremap <leader>cp :CtrlP 
nnoremap <leader>ct :CtrlPBufTagAll<CR>
nnoremap <leader>cl :CtrlPLine<CR>
nnoremap <leader>cq :CtrlPQuickfix<CR>
nnoremap <leader>cb :CtrlPBuffer<CR>
nnoremap <leader>cm :CtrlPMRUFiles<CR>
nnoremap <leader><leader> :CtrlPLastMode --dir<CR>


" change font
nnoremap <F12> :set guifont=Inconsolata\ for\ Powerline\ 12<CR>
nnoremap <F11> :set guifont=terminus\ 8<CR>
nnoremap <F5> :Make<CR><CR>
nnoremap <F4> :Dispatch 
nnoremap <F2> :TMiniBufExplorer<CR>
nnoremap <F1> :TagbarToggle<CR>

" }}}


" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
