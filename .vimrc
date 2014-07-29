" Author: Jakub Sokołowski <panswiata@gmail.com>
" Source: https://github.com/PonderingGrower/dotfiles

" Preamble {{{
" VIM instad of VI

if has('vim_starting')
    set rtp+=~/.vim/bundle/neobundle.vim/
    set nocompatible
endif

call neobundle#rc(expand('~/.vim/bundle/'))

" }}}
" NeoBundle plugin management {{{

" let Neobundle manage Neobundle
NeoBundle 'Shougo/neobundle.vim'

" Other plugins
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'haya14busa/vim-easyoperator-line'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-dispatch'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'wellle/targets.vim'
NeoBundle 'tommcdo/vim-exchange'
NeoBundle 'LaTeX-Box-Team/LaTeX-Box'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'mattn/ctrlp-register'
NeoBundle 'PProvost/vim-ps1'
NeoBundle 'vim-scripts/vis'
NeoBundle 'rking/ag.vim'
NeoBundle 'junegunn/vim-easy-align'
NeoBundle 'bling/vim-airline'
"NeoBundle 'takac/vim-hardtime'
NeoBundle 'eiginn/netrw'
NeoBundle "MarcWeber/vim-addon-mw-utils"
NeoBundle "tomtom/tlib_vim"
NeoBundle 'garbas/vim-snipmate'
NeoBundle 'honza/vim-snippets'
if ( has("lua") )
    NeoBundle 'Shougo/neocomplete'
endif
" colorschemes
NeoBundle 'nanotech/jellybeans.vim'

" }}}
" Display configuration {{{
"
syntax on                         " File-type highlighting
filetype on                       " enable file type detection
filetype plugin on                " loading of plugin files for all formats
filetype indent on                " loading of indent files for all formats

set background=dark

if &t_Co == 256 || has('gui_running')
    colors jellybeans
else
    colors jellybeans             " or some other 16-color scheme
endif

if has("gui_running") && has('vim_starting')
    if has("gui_gtk2")
        set guifont=Terminus\ 10
    elseif has("gui_win32")
        set guifont=Dina:h10:cANSI
    endif
endif

set guioptions=c                  " Get rid of useless GUI elements
set winwidth=78                   " minimum split width

set winheight=15                  " minimum split height
set colorcolumn=80                " highlight this column
set nuw=4                         " number line width
set ruler                         " show columns and rows
set cursorline                    " highlight the current line
set laststatus=2                  " always show the statusline
set number                        " show current line number
set relativenumber                " distance from the current line
set wrap                          " text wrapping
set linebreak                     " don't break in middle of words
set showmatch                     " show matching brackets
set t_vb=                         " don't flash the screen on errors
set previewheight=25              " height of windows for fugitive, etc
set splitright                    " new windows right to the current
let g:is_posix=1                  " enable better bash syntax highlighting
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
set shiftwidth=4                  " spaces for each step of (auto)indendt
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
set virtualedit=block             " allow to go beyond blank space in visual m.
set mouse=a                       " Enable the use of the mouse.
set scrolloff=5                   " number of lies vim won't scroll below
set showcmd                       " Show (partial) command in status line.
set noshowmode                    " don't show mode in command line
set showmatch                     " show match when a bracket is inserted
set autoread                      " automatically update file changes
set autoindent                    " breaks pasted in text, use F8 in insert
set preserveindent
set clipboard=unnamed             " paste the clipboard to unnamed register
set backspace=indent,eol,start    " go with backspace insert mode starting pos
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
set smartcase                     " ignore case unless upper case used
set iskeyword+=$,@,%,#            " not word dividers
"set iskeyword-=_                  " word dividers
set tags=tags;/                   " search for ctags in pwd and go up
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
"set foldtext=NeatFoldText()       " change how folds are desplayed when closed

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

" spelling settings
augroup latexsettings
    autocmd!
    autocmd FileType tex setlocal spell
    autocmd FileType tex setlocal foldmethod=expr
augroup END

" }}}
" Plugin configuration {{{

" Hardtime
let g:hardtime_default_on = 1
let g:hardtime_maxcount = 2
let g:hardtime_allow_different_key = 1

" NetRW
"let g:netrw_winsize       = 30
let g:netrw_banner        = 0
let g:netrw_liststyle     = 3
let g:netrw_browse_split  = 4
let g:netrw_preview       = 1
let g:netrw_altv          = 1
let g:netrw_fastbrowse    = 2
let g:netrw_keepdir       = 0
let g:netrw_retmap        = 1
let g:netrw_silent        = 1
let g:netrw_special_syntax= 1

" Airline
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_left_alt_sep = '|'
let g:airline_right_alt_sep = '|'
let g:airline_theme='powerlineish'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#whitespace#enabled = 0
" disable to improve fugitive performance
let g:airline#extensions#branch#enabled = 0

" Don't make comments italic
let g:jellybeans_use_lowcolor_black = 0
let g:jellybeans_overrides = {
            \ 'Comment':{ 'cterm': 'italic' },
            \ 'Todo':   { 'gui' : 'bold', 'guibg': 'ff0000', 'cterm': '224'},
            \ 'Folded': { 'guifg': 'dddddd', 'guibg': '333333'},
            \ 'MatchParen': { 'guifg': 'dddddd', 'guibg': 'de3a3a'}
            \}

highlight Normal ctermbg=NONE
highlight nonText ctermbg=NONE

" Stop CtrlP from recalculating on files on start
let g:ctrlp_user_command = 'ag %s -l -a --nocolor -g ""'
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
let g:EasyMotion_leader_key = '<space>'
let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz'
let g:EasyMotion_smartcase = 1
let g:EasyMotion_startofline = 0
let g:EasyMotion_do_special_mapping = 1

" neocomplete
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" use neocomplete
let g:neocomplete#enable_at_startup = 1
" use smartcase.
let g:neocomplete#enable_smart_case = 1
" set minimum syntax keyword length
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Latex-Box
" enabel folding by default
let g:LatexBox_Folding=1
" don't focus quickfix window
let g:LatexBox_quickfix=2
" don't show just warnings
let g:LatexBox_show_warnings=0
" compile in the background
let g:LatexBox_latexmk_async=1
" automatically compile
let g:LatexBox_latexmk_preview_continuously=1
" fold table of contents
let g:LatexBox_fold_toc=1
" use evince for viewing pdf
let g:LatexBox_viewer='evince'

" For snippet_complete marker.
if has('conceal')
   set conceallevel=2 concealcursor=i
endif

" }}}
" Key mappings - Plugins {{{

" neocomplete
inoremap <expr><tab>  pumvisible() ? "\<C-n>" : "\<TAB>"

if exists('*neocomplete#close_popup')
    " refresh completion when deleting a character
    inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    " confirm selection
    inoremap <expr><CR> neocomplete#close_popup()."\<CR>"
endif

" easy-align
xnoremap <silent> <cr> :EasyAlign<cr>
xnoremap <silent> <space><cr> :LiveEasyAlign<cr>

" easymotion
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)
" fast search by letter
nmap <CR> <Plug>(easymotion-s)

" easyoperator
nmap d<space>l <Plug>(easyoperator-line-delete)
nmap y<space>l <Plug>(easyoperator-line-yank)

" SnipMate

imap <C-S> <Plug>(snipMateNextOrTrigger)
smap <C-S> <Plug>(snipMateNextOrTrigger)

" surround
" c style comments using *
let g:surround_42 = "/* \r */"
" Powershell comments
let g:surround_35 = "<# \r #>"
" Powershell variable brackets for strings
let g:surround_36 = "$(\r)"

" }}}
" Key mappings - General {{{

" Toggle pastemode, doesn't indent
set pastetoggle=<F8>

" Changing leader
let mapleader = ","
let maplocalleader = "\\"

" easier access to commands
nnoremap ; :<c-f>
nnoremap : ;
nnoremap q; :
xnoremap ; :<c-f>
xnoremap : ;
xnoremap q; :

" easier escape to normal mode
inoremap jk <esc>
inoremap kj <esc>

" search within visual block
xnoremap / <esc>/\%V

" For closing tags in HTML
iabbrev </ </<C-X><C-O>

" jump forward or backward to any type of bracket
"nnoremap <CR> /[[({]<CR>zz
"nnoremap <S-CR> /[])}]<CR>zz

" reselect visual block after indent/outdent
xnoremap < <gv
xnoremap > >gv

" make last typed word uppercase
inoremap <c-u> <esc>viwUea

" save and compile
nnoremap mm :Make<CR>

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

" run last used macro with one key
nnoremap Q @@

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

nnoremap <space>v :execute getline(".")<cr>;w

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

" strip all trailing whitespaces in current file
nnoremap <space>O :%s/\s\+$//<cr>:let @/=''<CR>;

" open console in current directory
nnoremap <space>C :Start<CR>

" make latex
nnoremap <space>m :Latexmk<CR>
nnoremap <space>M :LatexView<CR>

" calculate current line with precision of 2
nnoremap <space>x yy:.!echo "scale=2; <c-r>"<c-h>"\|bc<CR>

" focus the current fold
nnoremap <space>z zMzv

" add new line above and bellow current line
nnoremap <silent> <space>[ :<C-U>call <SID>AddLines(1)<CR>
nnoremap <silent> <space>] :<C-U>call <SID>AddLines(0)<CR>

" performance debugging
nnoremap <silent> <LocalLeader>dd :exe ":profile start /tmp/profile.log"<cr>
                                \ :exe ":profile func *"<cr>
                                \ :exe ":profile file *"<cr>
                                \ :exe "echo 'Profiling vim performance...'"<cr>
nnoremap <silent> <LocalLeader>dq :exe ":profile pause"<cr>
                                \ :exe ":!gvim /tmp/profile.log"<cr>
                                \ :exe ":noautocmd qall!"<cr>

" }}}
" Key mappings - CtrlP {{{

nnoremap <c-i>      :CtrlPMixed<CR>
nnoremap <space>pp :CtrlP<Space>
nnoremap <space>pc :CtrlP %:p:h<CR>
nnoremap <space>pr :CtrlPRegister<CR>
nnoremap <space>p/ :CtrlPRoot<CR>
nnoremap <space>pt :CtrlPBufTagAll<CR>
nnoremap <space>pl :CtrlPLine<CR>
nnoremap <space>pq :CtrlPQuickfix<CR>
nnoremap <space>pb :CtrlPBookmarkDir<CR>
nnoremap <space>pm :CtrlPMRUFiles<CR>
nnoremap <space>po :CtrlPLastMode --dir<CR>

" search openned buffers
nnoremap <space><space> :CtrlPBuffer<CR>

" }}}
" Key mappings - Git {{{

" fugitive git bindings
nnoremap <space>ga :Git add -- "%:p"<CR><CR>
nnoremap <space>gs :Gstatus<CR>
nnoremap <space>gc :Gcommit -v -q<CR>
nnoremap <space>gt :Gcommit -v -q -- "%:p"<CR>
nnoremap <space>gd :Gdiff<CR>
nnoremap <space>ge :Gedit<CR>
nnoremap <space>gr :Gread<CR>
nnoremap <space>gu :Git reset "%:p"<CR><CR>
nnoremap <space>gw :Gwrite<CR><CR>
nnoremap <space>gl :silent! Glog<CR>:bot copen<CR>
nnoremap <space>gp :Ggrep<Space>
nnoremap <space>gm :Gmove<Space>
nnoremap <space>gb :Git branch<Space>
nnoremap <space>go :Git checkout<Space>
nnoremap <space>gps :Dispatch! git push<CR>
nnoremap <space>gpl :Dispatch! git pull<CR>

" }}}
" Key mappings - Fxx {{{

nnoremap <F12> :set guifont=Inconsolata\ 12<CR>
nnoremap <F11> :set guifont=terminus\ 10<CR>
nnoremap <F10> :Start %:p<CR>
nnoremap <F9>  :Dispatch %:p<CR>
nnoremap <F8>  :setlocal list!<CR>
nnoremap <F7>  :setlocal wrap!<CR>
nnoremap <F6>  :setlocal hlsearch!<CR>
nnoremap <F5>  :setlocal spell!<CR>
nnoremap <F4>  :<cr>
nnoremap <F3>  :vnew<cr>:setlocal buftype=nofile bufhidden=wipe nobuflisted<cr>
nnoremap <F2>  :<c-f>ivert bot help<space>
nnoremap <F1>  :exe ":!urxvtc -e man ".shellescape(expand('<cword>'), 1)<cr><cr>

" }}}
" autocmd settings {{{

" Return to last edit position when opening files (You want this!)
augroup saveposition
    autocmd!
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \   exe "normal! g`\"" |
                \ endif
augroup END

augroup awesomerc
    autocmd!
    " Check awesome configuration after every write
    autocmd BufWritePost $HOME/.config/awesome/rc.lua Dispatch awesome -k
augroup END

augroup file_settings
    autocmd!
    " per file syntax
    autocmd BufRead,BufNewFile .pentadactylrc set filetype=vim
    " per file foldmethod
    autocmd BufRead,BufNewFile rc.lua set foldmethod=marker
    autocmd BufRead,BufNewFile .vimrc set foldmethod=marker
    autocmd BufWritePost *.tex Latexmk!
augroup END

augroup MyAutoCmd
    autocmd!
    autocmd CmdwinEnter * call s:init_cmdwin()
    autocmd CmdwinLeave * let g:neocomplcache_enable_auto_select = 1
augroup END

augroup fugitive_settings
    autocmd!
    " same bindings for merging diffs as in normal mode
    autocmd BufRead fugitive://* xnoremap <buffer> dp :diffput<cr>
    autocmd BufRead fugitive://* xnoremap <buffer> do :diffget<cr>
    " easy diff update
    autocmd BufRead fugitive://* xnoremap <buffer> du :diffupdate<cr>
augroup END

augroup quickfix_settings
    autocmd!
    autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
augroup EN

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

" configure neocomplete to complete in command window
function! s:init_cmdwin()
    " leave command window quicker
    nnoremap <buffer><silent> q :<C-u>quit<CR>
    nnoremap <buffer><silent> <tab> :<C-u>quit<CR>

    " use tab for completion
    inoremap <buffer><expr><tab>  pumvisible() ? "\<C-n>" : "\<TAB>"

    " get normal <CR> behaviour
    nnoremap <buffer><cr> <cr>

    if exists('*neocomplete#close_popup')
        let g:neocomplcache_enable_auto_select = 0
        let b:neocomplcache_sources_list = ['vim_complete']

        " refresh completion when deleting a character
        inoremap <buffer><expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
        inoremap <buffer><expr><BS> neocomplete#smart_close_popup()."\<C-h>"

        " confirm selection
        inoremap <buffer><expr><CR> neocomplete#close_popup()."\<CR>"
    endif

    startinsert!
endfunction

" }}}
