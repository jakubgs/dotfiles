" Author: Jakub Sokołowski <panswiata@gmail.com>
" Source: https://github.com/PonderingGrower/dotfiles

" Preamble {{{
" VIM instad of VI

if has('vim_starting')
    set rtp+=~/.vim/bundle/neobundle.vim/
    set nocompatible
endif

call neobundle#begin(expand('~/.vim/bundle/'))

" }}}
" NeoBundle plugin management {{{

" let Neobundle manage Neobundle
NeoBundleFetch 'Shougo/neobundle.vim'

" Other plugins
NeoBundle 'ardagnir/vimbed'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'haya14busa/vim-easyoperator-line'
NeoBundle 'gregsexton/gitv'
NeoBundle 'sotte/presenting.vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-dispatch'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'wellle/targets.vim'
NeoBundle 'tommcdo/vim-exchange'
NeoBundle 'dbext.vim'
"NeoBundle 'LaTeX-Box-Team/LaTeX-Box'
"NeoBundle 'PProvost/vim-ps1'
"NeoBundle 'jceb/vim-orgmode'
"NeoBundle 'ntpeters/vim-better-whitespace'
NeoBundle 'xolox/vim-misc'
NeoBundle 'xolox/vim-easytags'
NeoBundle 'tsukkee/unite-tag'
NeoBundle 'Shougo/neossh.vim'
NeoBundle 'vim-scripts/vis'
NeoBundle 'bling/vim-airline'
NeoBundle 'eiginn/netrw'
NeoBundle 'tell-k/vim-autopep8'
NeoBundle 't9md/vim-chef'
NeoBundle 'dbakker/vim-projectroot'
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'kmnk/vim-unite-giti'

" Python plugins
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'bps/vim-textobj-python'
NeoBundle 'hynek/vim-python-pep8-indent'
NeoBundle 'ivanov/vim-ipython'

" Shougo
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
if ( has("lua") )
    NeoBundle 'Shougo/neocomplete'
endif
" colorschemes
NeoBundle 'nanotech/jellybeans.vim'

call neobundle#end()

" check for uninstalled bundles
NeoBundleCheck

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
set ttimeoutlen=50                " avoid lag when updating statusline
set colorcolumn=81                " highlight this column
set nuw=4                         " number line width
set ruler                         " show columns and rows
set cursorline                    " highlight the current line
set laststatus=2                  " always show the statusline
set number                        " show current line number
set relativenumber                " distance from the current line
set nowrap                          " text wrapping
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

set regexpengine=2                " might affect hanging of vim
set title                       " keep the console title unchanged
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
set shell=bash                     " Shell
let $SSH_AUTH_SOCK='/run/user/1000/ssh-agent.socket'
set keywordprg=firefox\ -search   " K searches text in firefox def. search
set grepprg=ag\ --nogroup\ --nocolor " use ag over grep
set shortmess=aoOtTI                 " remove message at vim start
set cmdheight=1                   " command line length
set backupdir=~/.vim/backup//     " make ~ files in:
set noswapfile                    " set directory=~/.vim/temp//
set hlsearch                      " highlighting search results
set incsearch                     " start searching as you type
set ignorecase                    " ignore case...
set smartcase                     " unless upper case used
set iskeyword+=$,@,%,#            " not word dividers
"set iskeyword-=_                  " word dividers
set hidden                        " buffer change, more undo
set ttyfast                       " Faster standard output
set completeopt-=preview          " disable the preview window
set wildmenu                      " File menu
set wildmode=list:longest,full    " ignore case when opening files
set wildignore=.so,.swp,.zip,.mp3,
            \.bak,.pyc,.o,.ojb,.,a,
            \ojb.pdf,.jpg,.gif,.png,
            \.avi,.mkv,.so,.out,.fls,.pdf
            \.aux,.fls,.out,.fdb_latexmk

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

" IPython response time
set updatetime=1000

" DBExt
" Codility database through readonly yunnel
let g:dbext_default_profile_codility = 
\ 'type=PGSQL:user=readonly:dbname=codility:passwd=readonly:host=127.0.0.1:port=15432'

" Easytags
" split ctags files by language
let g:easytags_by_filetype = '~/.vimtags/'
let g:easytags_always_enabled = 1
let g:easytags_async = 1

" by default start in home directory
let b:projectroot = '~/'

" Gitv
let g:Gitv_OpenHorizontal = 1

" Orgmode
let g:org_agenda_files = ['~/org/*.org']

" Unite
" max fuzzy match input length
let g:unite_matcher_fuzzy_max_input_length = 30
" default to fuzzy searching
call unite#filters#matcher_default#use(['matcher_glob'])
let g:unite_fuzzy_matching = 0
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#custom#profile('default', 'context', { 
\   'winheight': 40,
\   'smartcase' : 1,
\   'no_split' : 1,
\   'start_insert' : 1 })
" ignore these hidden directories
call unite#custom#source('file_rec/async', 'max_candidates', 200)
" Using ag as recursive command.
if executable('ag')
    " Use ag in unite file_rec/async source
    let g:unite_source_rec_async_command =
                \ 'ag --nocolor --nogroup -g ""'
    " worker-xquery.js is a ridiculously huge js file and breaks ag
	" Use ag in unite grep source.
	let g:unite_source_grep_command = 'ag'
	let g:unite_source_grep_default_opts =
	            \ '-i -U --line-numbers --nocolor --nogroup '
	let g:unite_source_grep_recursive_opt = ''
endif


" Conque GDB
let g:ConqueGdb_SrcSplit = 'right'

" Hardtime
let g:hardtime_default_on = 1
let g:hardtime_maxcount = 2
let g:hardtime_allow_different_key = 1

" NetRW
"let g:netrw_winsize       = 30
let g:netrw_mousemaps     = 0
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
let g:airline_section_c='%F'
let g:airline_detect_modified=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':p:~'
let g:airline#extensions#whitespace#enabled = 0
" disable to improve fugitive performance
let g:airline#extensions#branch#enabled = 1

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

" for snippet_complete marker.
if has('conceal')
   set conceallevel=0 concealcursor=i
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

" neosnippet
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

autocmd FileType python setlocal omnifunc=pythoncomplete#Complete

" easymotion
" fast search by letter
nmap <s-cr> <Plug>(easymotion-s)

" easyoperator
nmap d<space>l <Plug>(easyoperator-line-delete)
nmap y<space>l <Plug>(easyoperator-line-yank)

" easytags
nmap <space>U :execute('UpdateTags -R '.g:projectroot)<CR>

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
set pastetoggle=<F4>

" easier resizing
nnoremap <up>    :resize +5<CR>
nnoremap <down>  :resize -5<CR>
nnoremap <left>  :vert resize -5<CR>
nnoremap <right> :vert resize +5<CR>

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

" For closing tags in HTML
iabbrev </ </<C-X><C-O>

" search visually selected text
vnoremap * y/<c-r>"<cr>

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

" easier toggling between two buffers
nnoremap <c-cr> <c-^>

" jump forward or backward to any type of bracket
"nnoremap <CR> /[[({]<CR>zz
"nnoremap <S-CR> /[])}]<CR>zz

" }}}
" Key mappings - <Leader> {{{

" copy file path to clipboard
nnoremap <space>p :let @* = expand("%:p") <bar> let @+ = @*<CR>

" execute current line in vim
nnoremap <space>v :execute getline(".")<cr>;w

" put last searched items into QuickFix window
nnoremap <space>/ :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

" use Ag for searching
nnoremap <space>? :Ag<Space>

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
nnoremap <space>S :%s/\v

" copy whole file
nnoremap <space>a :%y+<CR>

" Window management
" close buffer but leave active pane open
nnoremap <silent> <space>q :bnext<bar>bd#<CR>
nnoremap <silent> <space>Q :q!<CR>

" Edit .vimrc and refresh configuration
nnoremap <silent> <space>r :source ~/dotfiles/.vimrc<CR>
nnoremap <silent> <space>R :vsp ~/dotfiles/.vimrc<CR>

" switch between buffers
nnoremap <silent> <space>h :bprevious<CR>
nnoremap <silent> <space>l :bnext<CR>
" toggle last two buffers
nnoremap <space>o <c-^>

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
" Key mappings - Unite {{{
nnoremap <c-i>     :execute('Unite buffer file_mru file_rec/async:'.g:projectroot)<CR>
nnoremap <space>uy :Unite -quick-match history/yank<CR>
nnoremap <space>ur :Unite -quick-match register<CR>
nnoremap <space>uR :Unite resume<CR>
nnoremap <space>uu :Unite file<CR>
nnoremap <space>um :Unite file_mru<CR>
nnoremap <space>ub :Unite buffer<CR>
nnoremap <space>uB :Unite -auto-preview grep:$buffers<CR>
nnoremap <space>uf :Unite file<CR>
nnoremap <space>uc :Unite command<CR>
nnoremap <space>ul :Unite line<CR>
nnoremap <space>ug :execute('Unite -auto-preview grep:'.g:projectroot)<CR>
nnoremap <space>uG :execute('Unite -auto-preview grep:'.g:projectroot.'::'.expand('<cword>'))<CR>
nnoremap <space>uj :Unite jump<CR>
nnoremap <space>ul :Unite line<CR>
nnoremap <space>um :Unite file_mru<CR>
nnoremap <space>us :Unite source<CR>
nnoremap <space>ut :Unite tag<CR>
nnoremap <space>uu :Unite file<CR>
nnoremap <space>up :UniteWithProjectDir file_rec/async<CR>
nnoremap <space>uI :Unite file_rec/async:~/work/infrastructure<CR>
nnoremap <space>uC :Unite file_rec/async:~/work/codility<CR>
nnoremap <space>uW :Unite file:~/work/<CR>


" search openned buffers
nnoremap <space><space> :Unite buffer<CR>
" }}}
" Key mappings - Git {{{

" fugitive git bindings
nnoremap <space>ga :Git add -- "%:p"<CR><CR>
nnoremap <space>gs :Gstatus<CR>
nnoremap <space>gc :Gcommit -v -q<CR>
nnoremap <space>gt :Gcommit -v -q -- "%:p"<CR>
nnoremap <space>gd :Gvdiff<CR>
nnoremap <space>ge :Gedit<CR>
nnoremap <space>gr :Gread<CR>
nnoremap <space>gu :Git reset "%:p"<CR><CR>
nnoremap <space>gw :Gwrite<CR><CR>
nnoremap <space>gl :silent! Glog<CR>:bot copen<CR>
nnoremap <space>gp :Ggrep<Space>
nnoremap <space>gm :Gmove<Space>
nnoremap <space>gB :Gblame<CR>
nnoremap <space>go :Git checkout<Space>
nnoremap <space>gps :Dispatch! git push<CR>
nnoremap <space>gpl :Dispatch! git pull<CR>
nnoremap <space>gf :Dispatch! git fetch --all<CR>

nnoremap <space>gv :Gitv<CR>
nnoremap <space>gV :Gitv!<CR>
nnoremap <space>gg :Unite giti<CR>
nnoremap <space>gb :Unite giti/branch<CR>

nnoremap <space>gSs :Git status <bar>
                    \ if confirm('Do you want to stash changes?') <bar>
                        \ Git stash --include-untracked <bar>
                    \ endif<CR><CR>
nnoremap <space>gSa :Git stash list --date=local <bar>
                    \ if confirm('Apply stash@{0}?') <bar>
                        \ Git stash apply <bar>
                    \ endif<CR><CR>

" }}}
" Key mappings - Fxx {{{

nnoremap <F12> :set guifont=terminus\ 16<CR>
nnoremap <F11> :set guifont=terminus\ 10<CR>
nnoremap <F10> :Dispatch! knife dwim ./<CR>
nnoremap <F9>  :Dispatch %:p<CR>
nnoremap <F8>  :setlocal list!<CR>
nnoremap <F7>  :setlocal wrap!<CR>
nnoremap <F6>  :setlocal hlsearch!<CR>
nnoremap <F5>  :setlocal spell!<CR>
" nnoremap <F4> is already set as pastetoggle
nnoremap <F3>  :vnew<cr>:setlocal buftype=nofile bufhidden=wipe nobuflisted<cr>
nnoremap <F2>  :<c-f>vert bot help<space>
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

augroup ruby_settings
    autocmd FileType ruby setlocal tabstop=2
    autocmd FileType ruby setlocal softtabstop=2
    autocmd FileType ruby setlocal shiftwidth=2
    autocmd FileType ruby setlocal cinoptions=>2
augroup END

augroup awesomerc
    autocmd!
    " Check awesome configuration after every write
    autocmd BufWritePost */.config/awesome/rc.lua Dispatch awesome -k
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
augroup END

augroup autoresize
    autocmd VimResized * exe "normal! \<c-w>="
augroup END

augroup projectroot
    autocmd!
    autocmd BufEnter * let g:projectroot = projectroot#guess()
augroup END

"augroup chef_settings
    "autocmd BufNewFile,BufRead */infrastructure/*  call s:SetupChef()
"augroup END

" Custom mappings for the unite buffer
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
    imap <buffer> <esc> <c-u><bs>
    nnoremap <buffer><cr> <cr>

    " move between lines
    imap <buffer> <C-j>   <Plug>(unite_select_next_line)
    imap <buffer> <C-k>   <Plug>(unite_select_previous_line)

    " open in new splits
    imap <silent><buffer><expr> <C-x> unite#do_action('split')
    imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
endfunction

au BufRead,BufNewFile *nginx* setfiletype nginx

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

" for setting up chef
function! s:SetupChef()
    " Mouse:
    " Left mouse click to GO!
    nnoremap <buffer><silent> <2-LeftMouse> :<C-u>ChefFindAny<CR>
    " Right mouse click to Back!
    nnoremap <buffer><silent> <RightMouse> <C-o>

    " Keyboard:
    nnoremap <buffer><silent> <c-a> :<C-u>ChefFindAny<CR>
    nnoremap <buffer><silent> <c-f> :<C-u>ChefFindAnyVsplit<CR>
endfunction

" }}}
