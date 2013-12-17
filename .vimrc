" Author: Jakub Sokołowski <panswiata@gmail.com>
" Source: https://github.com/PonderingGrower/dotfiles

" Preamble {{{
" VIM instad of VI
set nocompatible
" custom statusline
filetype off " required!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" }}}
" Vundle plugin management {{{
" let Vundle manage Vundle
Bundle 'gmarik/vundle'
Bundle 'liujoey/vim-easymotion'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-dispatch'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-repeat'
Bundle 'int3/vim-extradite'
Bundle 'LaTeX-Box-Team/LaTeX-Box'
Bundle 'kien/ctrlp.vim'
Bundle 'mattn/ctrlp-register'
Bundle 'PProvost/vim-ps1'
Bundle 'szw/vim-tags'
Bundle 'vim-scripts/vis'
Bundle 'rking/ag.vim'
Bundle 'junegunn/vim-easy-align'
Bundle 'plasticboy/vim-markdown'
Bundle 'bling/vim-airline'
Bundle 'Shougo/neosnippet'
if ( has("lua") )
    Bundle 'Shougo/neocomplete'
endif
" colorschemes
Bundle 'nanotech/jellybeans.vim'

" }}}
" Display configuration {{{
set background=dark

if &t_Co == 256 || has('gui_running')
    colors jellybeans
else
    colors jellybeans             " or some other 16-color scheme
endif

if has("gui_running")             " graphical font
    if has("gui_gtk2")
        set guifont=Terminus\ 10
    elseif has("gui_win32")
        set guifont=Dina:h10:cANSI
    endif
endif

syntax on                         " File-type highlighting
filetype on                       " enable file type detection
filetype plugin on                " loading of plugin files for all formats
filetype indent on                " loading of indent files for all formats

set guioptions=                   " Get rid of useless GUI elements
set winwidth=78                   " minimum split width
set winheight=15                  " minimum split height
set colorcolumn=80                " highlight this column
set nuw=4                         " number line width
set ruler                         " show columns and rows
set cursorline                    " highlight the current line
set laststatus=2                  " always show the statusline
set number                        " shot current line number
set relativenumber                " distance from the current line
set wrap                          " text wrappingi
set linebreak                     " don't break in middle of words
set showmatch                     " show matching brackets
set t_vb=                         " don't flash the screen on errors
set previewheight=25              " height of windows for fugitive, etc
set splitright                    " new windows right to the current
if has("multi_byte")
    set fillchars=vert:│,fold:-       " smooth windows splits
    set listchars=tab:▸\ ,eol:¬       " visible chars for tabs and EOLs
endif

" }}}
" Formatting settings {{{

set expandtab                     " use spaces instead of tabs
set smarttab                      " ;
set tabstop=4                     " spaces in <tab>
set softtabstop=4                 " spaces in <tab> when editing
set shiftwidth=4                  " spaces for each step of (auto)indendj
set cinoptions=>4                 " how cindent indents lines in C programs

" }}}
" General configuration {{{

set notitle                       " keep the console title unchanged
set encoding=utf-8                " encoding
set fileencoding=utf-8
set history=1000                  " history of vim commands
set nomodeline                    " no options from first comment in file
set lazyredraw                    " faster macros processing
set visualbell                    " tell vim to shut up
set mouse=a                       " Enable the use of the mouse.
set scrolloff=5                   " number of lies vim won't scroll below
set showcmd                       " Show (partial) command in status line.
set noshowmode                    " don't show mode in command line
set showmatch                     " show match when a bracket is inserted
set autoread                      " automatically update file changes
set autoindent                    " breaks pasted in text, use F8 in insert
set preserveindent
set clipboard=unnamed             " paste the clipboard to unnamed register
set spelllang=pl,en               " spelling check
set autochdir                     " Automatically changing working dir
set shell=zsh                     " Shell
set keywordprg=firefox\ -search   " K searches text in firefox def. search
set grepprg=ag\ --nogroup\ --nocolor " use ag over grep
set shortmess=atI                 " remove message at vim start
set cmdheight=1                   " command line length
set backupdir=~/.vim/backup//     " make ~ files in:
set noswapfile                    " set directory=~/.vim/temp//
set hlsearch                      " highlighting search results
set incsearch                     " start searching as you type
set ignorecase                    " ignore case in search patterns
set iskeyword+=$,@,%,#          " not word dividers
set hidden                        " buffer change, more undo
set ttyfast                       " Faster standard output
set wildmenu                      " File menu
set wildmode=list:longest,full    " ignore case when opening files
set wildignore=.so,swp,.zip,.mp3,
            \.bak,.pyc,.o,.ojb,.,a,
            \ojb.pdf,.jpg,.gif,.png,
            \.avi,.mkv,.so,.out,.fls,.pdf

if has('patch072')                " check if patch exists to avoid errors
    set wildignorecase            " ignore case when autocompleting paths
endif
if has('persistent_undo')         " persistend undo history
    set undofile                  " Save undo's after file closes
    set undodir=~/.vim/undo//     " where to save undo histories
    set undolevels=100            " How many undos
    set undoreload=1000           " number of lines to save for undo
endif

" save the file as root (tee must be addedd as NOPASSWD to sudoers)
command! -bar -nargs=0 Sw :silent exe 'write !sudo tee % >/dev/null' | silent edit!

" }}}
" Folding settings {{{

set foldenable                    " when on all folds are closed
set foldlevel=1                   " folds with higher level will be closed
set foldmethod=marker             " by default fold based on markers
set foldnestmax=1                 " nest fold limit for indent/syntax modes
set foldtext=NeatFoldText()       " change how folds are desplayed when closed

" }}}
" Programming settings {{{

compiler gcc                      " real men use gcc
set makeprg=make\ -j6\ --silent   " default compilation command

" Different compiler depending on type of file
autocmd FileType c set makeprg=make\ -j6\ --silent
autocmd FileType lua set makeprg=awesome\ -k
autocmd FileType c set cindent
autocmd FileType c set foldmethod=syntax
autocmd FileType cpp set foldmethod=syntax
" Format for errors in QuickList
autocmd FileType java set errorformat=%A%f:%l:\ %m,%-Z%p^,%C\ \ :\ %m,%-C%.%#
autocmd FileType cpp set errorformat=%f:%l:%c:\ %m

" }}}
" Plugin configuration {{{

" NetRW
let g:netrw_liststyle= 3
let g:netrw_browse_split = 4
let g:netrw_preview = 1
let g:netrw_altv = 1

" Airline
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_left_alt_sep = '|'
let g:airline_right_alt_sep = '|'
let g:airline_theme='powerlineish'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#whitespace#enabled = 0

" Harttime
let g:hardtime_default_on = 1

" Don't make comments italic
let g:jellybeans_overrides = {
            \ 'Comment':{ 'cterm': 'italic' },
            \ 'Todo':   { 'gui' : 'bold', 'guibg': 'ff0000', 'cterm': '224'},
            \ 'Folded': { 'guifg': 'dddddd', 'guibg': '333333'},
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

" SuperTab
let g:SuperTabDefaultCompletionType = "context"

" TagBar
set tags=./tags;../tags;/
let g:tagbar_left = 1
let g:tagbar_width = 30
let g:tagbar_ctags_bin="/usr/bin/ctags"

" Stop CtrlP from recalculating on files on start
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
let g:ctrlp_cache_dir = $HOME.'/.vim/temp/ctrlp'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_match_window = 'min:5,max:20'
let g:ctrlp_show_hidden = 1
let g:ctrlp_working_path_mode = 'raw'
let g:ctrlp_regexp = 0
let g:ctrlp_root_markers = ['.root', '.git', 'COPYING' ]
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn)$',
    \ 'file': '\v\.(exe|so|dll|tmp|temp|swp|o)$',
    \ }

" EasyMotion leader
let g:EasyMotion_leader_key = '<Space>'
let g:EasyMotion_keys = 'qwertyuiopasdfghjklzxcvbnm'
let g:EasyMotion_special_select_line = 1
let g:EasyMotion_special_select_phrase = 1
let g:EasyMotion_do_normal_motion = 1

" neocomplete
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 4
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Latex-Box
" don't focus quickfix window
let g:LatexBox_quickfix=2
" don't show just warnings
let g:LatexBox_show_warnings=0
" compile in the background
let g:LatexBox_latexmk_async=0

" For snippet_complete marker.
if has('conceal')
   set conceallevel=2 concealcursor=i
endif

" }}}
" Key mappings - Plugins {{{

" <TAB>: completion for neocomplete
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" neosnippet mappings
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" easy-align
xnoremap <silent> <cr> :EasyAlign<cr>
xnoremap <silent> <space><cr> :LiveEasyAlign<cr>

" }}}
" Key mappings - General {{{

" Toggle pastemode, doesn't indent
set pastetoggle=<F8>

" Changing leader to space
let mapleader = ","
let maplocalleader = "\\"
" don't let space do anything else
nnoremap <SPACE> <Nop>

" easier access to commands
nnoremap ; :
nnoremap : ;
xnoremap ; :
xnoremap : ;

" search within visual block
xnoremap / <esc>/\%V

" For closing tags in HTML
iabbrev </ </<C-X><C-O>

" reselect visual block after indent/outdent
xnoremap < <gv
xnoremap > >gv

" Fast saving
nmap <c-s> :update<cr>
imap <c-s> <c-o>:update<cr>

" save and compile
map mm :Make<CR>

" for moving in wrapped lines
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" easier toggling of folds
nnoremap zz za

" center the screen
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" to match the behaviour of D
nnoremap Y y$

" for jumping forward
nnoremap <c-p> <c-i>

" easier navigation between splits
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

" easier navigation through tabs
nnoremap <c-Tab>   :tabnext<CR>
nnoremap <c-s-Tab> :tabprevious<CR>

" Learn to use hjkl
nnoremap <up> ddkP
nnoremap <down> ddp
nnoremap <left> gv<
nnoremap <right> gv>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" easier newline
inoremap <c-j> <cr>
inoremap <c-k> <c-o>O

" counterpart to <c-h> in insert mode
inoremap <c-l> <Del>

inoremap <c-z> <c-v>
" paste with ctrl+v from clipboard in insert mode
inoremap <c-v> <c-r>+
" paste to clipboard with ctrl+c in visual mode
xnoremap <c-c> "+y

" }}}
" Key mappings - <Leader> {{{

" paste and sellect
nnoremap <space>/ :Ag<Space>

" grep word under cursor
nnoremap <silent> <space>* :Ag "\b<C-R><C-W>\b"<CR>

" paste and sellect
nnoremap <space>o p`[v`]
nnoremap <space>O P`[v`]

" help in new vertical split
nnoremap <space>H :rightb vert help<space>

" append a semicolon
nnoremap <space>; A;<Esc>

" insert spaces between brackets
nnoremap <space>Y :CopyMatches *<CR>

" easier access to substitution
nnoremap <space>S :%s//<left>

" Window management
" split vertical and switch
nnoremap <space>i <C-w>v<C-w>l
" split horizontal and switch
nnoremap <space>o <C-w>s<C-w>l
" close buffer but leave active pane open
nnoremap <silent> <space>q :bp<bar>sp<bar>bn<bar>bd<CR>
nnoremap <silent> <space>Q :q!<CR>

" Edit .vimrc and refresh configuration
nnoremap <silent> <space>r :source ~/.vimrc<CR>
nnoremap <silent> <space>R :vsp ~/.vimrc<CR>

" switch between buffers
nnoremap <silent> <space>h :bprevious<CR>
nnoremap <silent> <space>l :bnext<CR>
" toggle last two buffers
nnoremap <space>u <c-^>

" roggle showing of newline and tab characters
nnoremap <space>I :set list!<CR>

" strip all trailing whitespaces in current file
nnoremap <space>O :%s/\s\+$//<cr>:let @/=''<CR>;

" open console in current directory
nnoremap <space>C :Start<CR>

" make latex
nnoremap <space>m :Latexmk<CR>
nnoremap <space>M :LatexView<CR>

" CtrlP mappings
nnoremap <c-i>      :CtrlPMixed<CR>
nnoremap <space>pp :CtrlP<Space>
nnoremap <space>pc :CtrlP %:p:h<CR>
nnoremap <space>pr :CtrlPRegister<CR>
nnoremap <space>p/ :CtrlPRoot<CR>
nnoremap <space>pt :CtrlPBufTagAll<CR>
nnoremap <space>pl :CtrlPLine<CR>
nnoremap <space>pq :CtrlPQuickfix<CR>
nnoremap <space>pb :CtrlPBuffer<CR>
nnoremap <space>pm :CtrlPMRUFiles<CR>
nnoremap <space>po :CtrlPLastMode --dir<CR>

" re-run last CtrlP command
nnoremap <space><space> :CtrlPBuffer<CR>

" set current dir to that of current file
nnoremap <space>g :cd %:p:h<CR>:pwd<CR>

" calculate current line with precision of 2
nnoremap <space>x yy:.!echo "scale=2; <c-r>"<c-h>"\|bc<CR>

" focus the current fold
nnoremap <space>z zMzv

" add new line above and bellow current line
nnoremap <silent> <space>[ :<C-U>call <SID>AddLines(1)<CR>
nnoremap <silent> <space>] :<C-U>call <SID>AddLines(0)<CR>

" performance debugging
nnoremap <silent> <space>DD :exe ":profile start /tmp/profile.log"<cr>
                                    \ <bar> profile func *"<cr>
                                    \ <bar> profile file *"<cr>
nnoremap <silent> <space>DQ :exe ":profile pause"<cr>:noautocmd qall!<cr>"

" }}}
" Key mappings - Git {{{

" fugitive git bindings
nnoremap ga :Git add %:p<CR><CR>
nnoremap gs :Gstatus<CR>
nnoremap gc :Gcommit -v -q<CR><c-w>H
nnoremap gt :Gcommit -v -q %:p<CR><c-w>H
nnoremap gd :Gdiff<CR>
nnoremap ge :Gedit<CR>
nnoremap gr :Gread<CR>
nnoremap gw :Gwrite<CR><CR>
nnoremap gl :Glog<CR>
nnoremap gp :Ggrep<Space>
nnoremap gm :Gmove<Space>
nnoremap gb :Git branch<Space>
nnoremap go :Git checkout<Space>
nnoremap gps :Dispatch! git push<CR>
nnoremap gpl :Dispatch! git pull<CR>

" }}}
" Key mappings - Fxx {{{

nnoremap <F12> :set guifont=Inconsolata\ 12<CR>
nnoremap <F11> :set guifont=terminus\ 8<CR>
nnoremap <F10> :SyntasticToggleMode<CR>
nnoremap <F9> :vsplit \| enew \| r !ls -l<CR><CR><c-w>L
nnoremap <F8> :Make!<CR>
nnoremap <F7> :Copen<CR>
nnoremap <F6> :tabclose<CR>
nnoremap <F5> :tabnew<CR>
nnoremap <F4> :source ~/.vim/session/default<cr>
nnoremap <F3> :mksession! ~/.vim/session/default<cr>
nnoremap <F1> :TagbarToggle<CR>

" }}}
" autocmd settings {{{

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif

" Check awesome configuration after every write
autocmd BufWritePost $HOME/.config/awesome/rc.lua Dispatch awesome -k

" per file syntax
autocmd BufRead,BufNewFile .pentadactylrc set filetype=vim
" per file foldmethod
autocmd BufRead,BufNewFile rc.lua set foldmethod=marker
autocmd BufRead,BufNewFile .vimrc set foldmethod=marker

" }}}
" Functions {{{

" Add []<space> mappings for adding empty lines
function! s:AddLines(before)
  let cnt = (v:count>0) ? v:count : 1
  call append(line('.')-a:before, repeat([''], cnt))
  silent! call repeat#set((a:before ? '[ ' : '] '), cnt)
endf

function! NeatFoldText()
  let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
  let foldchar = matchstr(&fillchars, 'fold:\zs.')
  let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
  let foldtextend = lines_count_text . repeat(foldchar, 8)
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction

" copies all found matches to provided register
function! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/ge
  let reg = empty(a:reg) ? '+' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register CopyMatches call CopyMatches(<q-reg>)

" }}}
