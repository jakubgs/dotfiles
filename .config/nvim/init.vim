" Author: Jakub Sokołowski <panswiata@gmail.com>
" Source: https://github.com/PonderingGrower/dotfiles

" Plugin management {{{

let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'

" auto-install vim-plug                                                                                                                
if empty(glob('~/.config/nvim/autoload/plug.vim'))                                                                                    
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall                                                                                                      
endif  
call plug#begin('~/.config/nvim/bundle')

" Misc plugins
Plug 'dbakker/vim-projectroot'
Plug 'sotte/presenting.vim'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-eunuch'
Plug 'xolox/vim-easytags'
Plug 'xolox/vim-misc'
Plug 'bruno-/vim-man'
Plug 'metakirby5/codi.vim'
Plug 'junegunn/goyo.vim'
" Movement
Plug 'justinmk/vim-sneak'
" Text manipulation
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tommcdo/vim-exchange'
Plug 'godlygeek/tabular'
Plug 'jkramer/vim-checkbox'
" Text objects
Plug 'kana/vim-textobj-user'
Plug 'Julian/vim-textobj-brace'
Plug 'kana/vim-textobj-indent'
" Git plugins
Plug 'tpope/vim-fugitive'
Plug 'gregsexton/gitv'
Plug 'kmnk/vim-unite-giti'
" Provisioning plugins
Plug 'chase/vim-ansible-yaml'
Plug 'hashivim/vim-terraform'
" Syntax
Plug 'robbles/logstash.vim'
"Plug 'tpope/vim-markdown'
Plug 'LaTeX-Box-Team/LaTeX-Box'
Plug 'LnL7/vim-nix'
Plug 'lepture/vim-jinja'
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'pangloss/vim-javascript',     { 'for': 'javascript' }
Plug 'fatih/vim-go'
Plug 'tomlion/vim-solidity'
" Haskell
Plug 'neovimhaskell/haskell-vim',   { 'for': 'haskell' }
Plug 'alx741/vim-hindent',          { 'for': 'haskell' }
" JS
Plug 'pangloss/vim-javascript',     { 'for': 'javascript' }
Plug 'mxw/vim-jsx'
Plug 'moll/vim-node'
Plug 'mxw/vim-jsx'
Plug 'tell-k/vim-autopep8',         { 'for': 'javascript' }
" Python plugins
Plug 'tell-k/vim-autopep8',         { 'for': 'python' }
Plug 'hynek/vim-python-pep8-indent',{ 'for': 'python' }
Plug 'bfredl/nvim-ipy',             { 'for': 'python' }
"Plug 'zchee/deoplete-jedi',         { 'for': 'python' }
Plug 'bps/vim-textobj-python',      { 'for': 'python' }
" Searching Plugins
Plug 'tsukkee/unite-tag'
Plug 'Shougo/unite.vim'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/neossh.vim'
" Completion
Plug 'Shougo/deoplete.nvim',
Plug 'Shougo/neco-vim'
" Style
Plug 'nanotech/jellybeans.vim'
Plug 'itchyny/lightline.vim'

call plug#end()

" }}}
" Start Server {{{

"call serverstart($NVIM_LISTEN_ADDRESS)

" }}}
" Display configuration {{{

let g:jellybeans_overrides = {
\    'background': { 'ctermbg': 'NONE', '256ctermbg': 'NONE', 'guibg': 'NONE' },
\}
set background=dark
colorscheme jellybeans

syntax on                         " File-type highlighting
filetype on                       " enable file type detection
filetype plugin on                " loading of plugin files for all formats
filetype indent on                " loading of indent files for all formats

set winwidth=40                   " minimum split width
set winheight=15                  " minimum split height
set ttimeoutlen=50                " avoid lag when updating statusline
"set colorcolumn=81                " highlight this column
set list                          " show tabs and newlines
set nuw=4                         " number line width
set ruler                         " show columns and rows
set cursorline                    " highlight the current line
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

" Make visual selection match lightline
hi! link Visual LightlineLeft_visual_0
hi! link Cursor LightlineLeft_normal_0

" }}}
" Formatting settings {{{

set autoindent
set expandtab                     " use spaces instead of tabs
set tabstop=4                     " spaces in <tab>
set softtabstop=4                 " spaces in <tab> when editing
set shiftwidth=4                  " spaces for each step of (auto)indendt
set cinoptions=>4                 " how cindent indents lines in C programs

" }}}
" General configuration {{{

set regexpengine=2                " might affect hanging of vim
"set encoding=utf-8                " encoding
set fileencoding=utf-8
set nomodeline                    " no options from first comment in file
set lazyredraw                    " faster macros processing
set visualbell                    " tell vim to shut up
set virtualedit=block             " allow to go beyond blank space in visual m.
set scrolloff=5                   " number of lies vim won't scroll below
set sidescroll=1                  " scroll sideways like a normal editor
set showcmd                       " Show (partial) command in status line.
set noshowmode                    " don't show mode in command line
set showmatch                     " show match when a bracket is inserted
set preserveindent
set clipboard=unnamedplus         " paste the clipboard to unnamed register
set spelllang=en,pl               " spelling check
set nospell
set autochdir                     " Automatically changing working dir
set shell=zsh                     " Shell
set keywordprg=firefox\ --new-tab\ --search " K searches text in firefox def. search
set grepprg=ag\ --nogroup\ --nocolor " use ag over grep
set shortmess=aoOtTI                 " remove message at vim start
set cmdheight=1                   " command line length
set backupdir=~/.config/nvim/backup//     " make ~ files in:
set noswapfile                    " set directory=~/.vim/temp//
set ignorecase                    " ignore case...
set smartcase                     " unless upper case used
set iskeyword+=$,@,%,#            " not word dividers
set iskeyword-=.,_                " word dividers
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
    set undodir=~/.config/nvim/undo//     " where to save undo histories
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

" }}}
" Programming settings {{{

"compiler gcc                      " real men use gcc
set makeprg=make\ -j6\ --silent   " default compilation command

" Different compiler depending on type of file
autocmd FileType c set makeprg=make\ -j6\ --silent
autocmd FileType lua set makeprg=awesome\ -k
autocmd FileType c set cindent
autocmd FileType c set foldmethod=syntax
autocmd FileType cpp set foldmethod=syntax
autocmd FileType cpp set errorformat=%f:%l:%c:\ %m

" }}}
" Plugin configuration {{{

" Markdown
let g:markdown_syntax_conceal = 1

let g:terraform_align = 1
let g:terraform_fold_sections = 1

let g:jsx_ext_required = 0

" Startify
let g:startify_session_dir = '~/.config/nvim/session'
let g:startify_session_persistence = 1
let g:startify_session_delete_buffers = 1
let g:startify_list_order = ['sessions', 'files' ]
let g:startify_files_number = 16
let g:startify_custom_header = [
\ '                           .oooooooooooooo.',
\ '                        .d888888888888888P',
\ '               db       88888888888888888boo.',
\ '              `Y8b      888888888888888888888b.',
\ '                `Yb....d88888888888888888888888b',
\ '                  `Y8888888888888888888888888888',
\ '          "8b  "8" "88888888888888888888888888P',
\ '           8Yb  8   88`Y8888888888888bo. """',
\ '           8 Yb 8   88-<`Y88888888888888bo.',
\ '           8  Yb8   88    `Y888888888888888b',
\ '          .8.  Y8  .88...d `Y88888888888888',
\ '                              `Y888888888888b',
\ '                       "88""Yb. YY88888888888b',
\ '                        88..bP"  YbY8888888888.',
\ '                        88""Yb    Yb`Y888888888',
\ '                        88   Yb    YdP`Y888888P',
\ '                       .88.   Yb    V   `Y8888b',
\ '                                          `Y888',
\ '                                            `Y8',
\]
let g:startify_custom_indices = map(range(1,100), 'string(v:val)')
highlight link StartifyPath   LineNr
highlight link StartifyFile   ModeMsg
highlight StartifyHeader      ctermfg=196 cterm=bold gui=bold

" Surround
" /* TEXT */ comments
let g:surround_42 = "/* \r */"

" Lightline
let g:lightline = { 'colorscheme': 'powerline', }

" Deoplete
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option({
\  'auto_complete_delay': 200,
\  'smart_case': v:true,
\})
call deoplete#custom#option('sources', {
\ '_': ['buffer'],
\ 'md': ['buffer', 'spell'],
\ 'cpp': ['buffer', 'tag'],
\})
"set completeopt+=noinsert " Enable auto selection

" Sneak
let g:sneak#label = 1
let g:sneak#target_labels = "abcdefghijklmnopqrstuvwxyz"
let g:sneak#s_next = 1
let g:sneak#use_ic_scs = 1
let g:sneak#prompt = 'STREAK>>>'

"hi link Sneak Visual
hi Sneak ctermfg=white ctermbg=88
hi SneakLabel ctermfg=white ctermbg=88
hi SneakScope ctermfg=grey ctermbg=grey

" IPython response time
set updatetime=1000

" Easytags
" split ctags files by language
let g:easytags_by_filetype = '~/.config/nvim/tags/'
let g:easytags_always_enabled = 1
let g:easytags_async = 1

" by default start in home directory
let g:projectroot = '~/work/'

" Gitv
let g:Gitv_OpenHorizontal = 1

" Unite
let g:unite_source_rec_min_cache_files = 500
" shorten time format for buffers, obscured filenames
let g:unite_source_buffer_time_format = '(%H:%M:%S)'
" default to fuzzy searching, hide current file
call unite#filters#sorter_default#use([
\   'matcher_fuzzy',
\   'matcher_hide_current_file'
\])
" https://github.com/Shougo/unite.vim/issues/1079
call unite#custom#profile('default', 'context', {
\   'smartcase': 1,
\   'no_split': 1,
\   'start_insert': 1,
\   'ignore_globs': [],
\   'short_source_names': 1,
\})
"" ignore these hidden directories
call unite#custom#source('file_rec/neovim', 'max_candidates', 200)
" Using ag as recursive command.
if executable('ag')
    " Use ag in unite file_rec/async source
    let g:unite_source_rec_async_command =
        \ ['ag','--follow','--nocolor','--nogroup','--hidden','-g','']
    " worker-xquery.js is a ridiculously huge js file and breaks ag
	" Use ag in unite grep source.
	let g:unite_source_grep_command = 'ag'
	let g:unite_source_grep_default_opts =
                \ '-i -U --line-numbers --nocolor --nogroup '
	let g:unite_source_grep_recursive_opt = ''
endif

" NeoMRU
" remember /mnt paths
let g:unite_source_file_mru_ignore_pattern = 
    \ substitute(g:neomru#file_mru_ignore_pattern, '|\/mnt\/\\', '', '')

" for snippet_complete marker.
if has('cSonceal')
   set conceallevel=0 concealcursor=i
endif

" }}}
" Key mappings - Plugins {{{

" Checkbox
nnoremap <space>t :ToggleCB<CR>

" Sneak
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T
xmap f <Plug>Sneak_f
xmap F <Plug>Sneak_F
xmap t <Plug>Sneak_t
xmap T <Plug>Sneak_T
nmap s <Plug>SneakLabel_s
nmap S <Plug>SneakLabel_S
nmap <c-j> f{
nmap <c-k> F]

" for snippet_complete marker.
if has('conceal')
   set conceallevel=0 concealcursor=i
endif

" Deoplete
" use tab to cycle
inoremap <silent><expr> <tab> pumvisible() ? "\<c-y>" : "\<tab>"
" dont select things with Enter
inoremap <silent><expr> <cr>  pumvisible() ? "\<c-e>\<cr>" : "\<cr>"

" easytags
nmap <space>U :execute('UpdateTags -R '.g:projectroot)<CR>

" }}}
" Key mappings - General {{{

" <TAB> completion
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" moving selected lines
xnoremap <silent> <c-k> :move-2<CR>gv=gv
xnoremap <silent> <c-j> :move'>+<CR>gv=gv

" easier escaping of :term
tnoremap <c-a> <c-\><c-n>

" easier resizing
nnoremap <up>    :resize -5<CR>
nnoremap <down>  :resize +5<CR>
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

" search visually selected text
vnoremap * y/<c-r>"<cr>

" reselect visual block after indent/outdent
xnoremap < <gv
xnoremap > >gv

" make last typed word uppercase
inoremap <c-u> <esc>viwUea

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

" source current file
nnoremap <c-s> :source %:p<CR>

" for jumping forward
nnoremap <c-p> <c-i>

" easier navigation between splits
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
" samething for :term
tnoremap <c-h> <c-\><c-n><c-w>h
tnoremap <c-j> <c-\><c-n><c-w>j
tnoremap <c-k> <c-\><c-n><c-w>k
tnoremap <c-l> <c-\><c-n><c-w>l

" easier navigation through tabs
nnoremap <c-Tab>   :wtabnext<CR>
nnoremap <c-s-Tab> :tabprevious<CR>

" copy to clipboard with ctrl+c in visual mode
xnoremap <c-c> "*y:call system('xclip -i -selection clipboard', @*)<CR>
" }}}
" Key mappings - <Leader> {{{

" copy file path to clipboard
nnoremap <space>p :let @* = expand("%:p") <bar> let @+ = @*<CR>

" execute current line in vim
nnoremap <space>v :execute getline(".")<cr>;w

" put last searched items into QuickFix window
nnoremap <space>/ :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

" paste and sellect
nnoremap <space>p p`[v`]
nnoremap <space>P P`[v`]

" help in new vertical split
nnoremap <space>H :rightb vert help<space>

" copy whole file
"nnoremap <space>a :%y+<CR>
nnoremap <space>a :%y*<CR>:call system('xclip -i -selection clipboard', @*)<CR>

" Window management
" close buffer but leave active pane open
nnoremap <silent> <space>q :bprevious<bar>bd! #<CR>
nnoremap <silent> <space>Q :<CR>

" Edit .vimrc and refresh configuration
nnoremap <silent> <space>r :source ~/dotfiles/.config/nvim/init.vim<CR>
nnoremap <silent> <space>R :vsp ~/dotfiles/.config/nvim/init.vim<CR>

" Open TODO
nnoremap <silent> <space>T :vsp ~/work/jakubgs-notes/todo.md<CR>

" switch between buffers
nnoremap <silent> <space>h :bprevious<CR>
nnoremap <silent> <space>l :bnext<CR>

" strip all trailing whitespaces in current file
nnoremap <space>O :%s/\s\+$//<cr>:let @/=''<CR>;

" make latex
nnoremap <space>m :Latexmk<CR>
nnoremap <space>M :LatexView<CR>

" calculate current line with precision of 2
nnoremap <space>x yy:.!echo "scale=2; <c-r>"<c-h>"\|bc<CR>

" focus the current fold
nnoremap <space>z zMzv

" performance debugging
nnoremap <silent> <LocalLeader>dd :exe ":profile start /tmp/profile.log"<cr>
                                \ :exe ":profile func *"<cr>
                                \ :exe ":profile file *"<cr>
                                \ :exe "echo 'Profiling vim performance...'"<cr>
nnoremap <silent> <LocalLeader>dq :exe ":profile pause"<cr>
                                \ :exe ":!urxvtc -e nvim /tmp/profile.log"<cr>
                                \ :exe ":noautocmd qall!"<cr>

" }}}
" Key mappings - Startify {{{
"
" MASTER STROKE - Repeat last command
nnoremap <c-space> @:<CR>

" Dispatch a command
nnoremap <space>d :Dispatch!<space>

nnoremap <space>S :Startify<CR>
nnoremap <space>ss :SSave<CR>
nnoremap <space>sl :SLoad<CR>
nnoremap <space>sc :SClose<CR>
nnoremap <space>sd :SDelete<CR>

" }}}
" Key mappings - Codi {{{
"
nnoremap <space>cc :Codi<CR>
nnoremap <space>cd :Codi!<CR>
nnoremap <space>ct :Codi!!<CR>
nnoremap <space>cu :CodiUpdate<CR>
nnoremap <space>cp :Codi python<CR>
nnoremap <space>cr :Codi ruby<CR>
nnoremap <space>cj :Codi javascript<CR>

" }}}
" Key mappings - Unite {{{
nnoremap <c-i>     :execute('Unite buffer file_rec/neovim:'.g:projectroot.' file_mru file/new')<CR>
nnoremap <space>uy :Unite -quick-match history/yank<CR>
nnoremap <space>ur :Unite -quick-match register<CR>
nnoremap <space>uR :Unite resume<CR>
nnoremap <space>uu :Unite file<CR>
nnoremap <space>um :Unite file_mru<CR>
nnoremap <space>ub :Unite buffer<CR>
nnoremap <space>uf :Unite file<CR>
nnoremap <space>uc :Unite command<CR>
nnoremap <space>ul :Unite line<CR>
nnoremap <space>uj :Unite jump<CR>
nnoremap <space>ul :Unite line<CR>
nnoremap <space>um :Unite file_mru<CR>
nnoremap <space>us :Unite source<CR>
nnoremap <space>ut :Unite tag<CR>
nnoremap <space>uu :Unite file<CR>
nnoremap <space>up :UniteWithProjectDir file_rec/neovim<CR>
nnoremap <space>uh :Unite file:~/<CR>
nnoremap <space>up :execute('Unite file_rec/neovim:'.g:projectroot)<CR>
nnoremap <space>uw :execute('Unite file:'.g:projectroot)<CR>

" location specific
"nnoremap <space>uW :Unite file_rec/neovim:~/work/<CR>
nnoremap <space>uW :Unite file:~/work/<CR>
nnoremap <space>uP :Unite file_rec/neovim:/mnt/melchior/projects<CR>
nnoremap <space>uh :Unite file:~/<CR>

" search openned buffers
nnoremap <space><space> :Unite buffer<CR>

" Go Lang mappings {{{
"
nnoremap <space>Gr :GoRun<CR>
nnoremap <space>Gt :GoTest<CR>
nnoremap <space>Gb :GoBuild<CR>
nnoremap <space>Gd :GoDebugStart<CR>
nnoremap <space>Gl :GoLint<CR>
nnoremap <space>Gv :GoVet<CR>
nnoremap <space>Ge :GoErrCheck<CR>
nnoremap <space>Gi :GoImport<space>
nnoremap <space>GR :GoRename<space>
nnoremap <space>Gf :GoDef<space>
nnoremap <space>Gd :GoDoc<space>
nnoremap <space>Gb :GoDocBrowser<space>
nnoremap <space>GI :GoInstall<CR>


" }}}
" Key mappings - Git {{{

" fugitive git bindings
nnoremap <space>gr :Gread<CR>
nnoremap <space>gs :Gstatus<CR>
nnoremap <space>gw :Gwrite<CR>
nnoremap <space>ga :Gwrite<CR>
nnoremap <space>gc :Gcommit -s -v -q -n<CR>
nnoremap <space>gt :Gcommit -s -v -q -n -- "%:p"<CR>
nnoremap <space>gC :Gcommit -s -v -q -n --amend<CR>
nnoremap <space>gT :Gcommit -s -v -q -n --amend -- "%:p"<CR>
nnoremap <space>gd :Gvdiff<CR>
nnoremap <space>ge :Gedit<CR>
nnoremap <space>gu :Git reset "%:p"<CR><CR>
nnoremap <space>gl :silent! Glog<CR>:bot copen<CR>
nnoremap <space>gp :Ggrep<Space>
nnoremap <space>gm :Gmove<Space>
nnoremap <space>gB :Gblame<CR>
nnoremap <space>go :Git checkout<Space>
nnoremap <space>gf  :Dispatch! git fetch --all<CR>
nnoremap <space>gps :Dispatch! git push<CR>
nnoremap <space>gpS :Dispatch! git push --force<CR>
nnoremap <space>gpl :Dispatch! git pull<CR>

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

nnoremap <F11> :Goyo 120<CR>
nnoremap <F10> :Dispatch! knife dwim %:p<CR>
nnoremap <F9>  :Dispatch %:p<CR>
nnoremap <F8>  :setlocal list!<CR>
nnoremap <F7>  :setlocal wrap!<CR>
nnoremap <F6>  :setlocal hlsearch!<CR>
nnoremap <F5>  :setlocal spell!<CR>
nnoremap <F3>  :vnew<cr>:setlocal buftype=nofile bufhidden=wipe nobuflisted<cr>
nnoremap <F2>  :<c-f>vert bot help<space>
nmap     <F1>  <Plug>(Vman)

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
    autocmd BufWritePost */.config/awesome/rc.lua Dispatch! awesome -k
augroup END

augroup file_settings
    autocmd!
    " per file syntax
    autocmd BufRead,BufNewFile .pentadactylrc set filetype=vim
    " per file foldmethod
    autocmd BufRead,BufNewFile rc.lua set foldmethod=marker
    autocmd BufRead,BufNewFile .nvimrc set foldmethod=marker
    autocmd BufWritePost *.tex Latexmk!
augroup END

augroup MyAutoCmd
    autocmd!
    autocmd CmdwinEnter * silent! call s:init_cmdwin()
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
    autocmd BufReadPost quickfix silent! nnoremap <buffer> <CR> <CR>
augroup END

augroup autoresize
    autocmd VimResized * silent! exe "normal! \<c-w>="
augroup END

augroup projectroot
    autocmd!
    autocmd BufEnter * silent! s:detectProjectRoot()
augroup END

au BufRead,BufNewFile *nginx* setfiletype nginx
au BufRead,BufNewFile *.trac setfiletype tracwiki

" }}}
" Functions {{{

" I want to avoid project root being just home.
" Too many files to search.
function! s:detectProjectRoot()
    let g:projectroot = projectroot#guess()
    if g:projectroot == expand('~/')
        let g:projectroot = expand('~/') . '/work'
    endif
endfunction

" Add []<space> mappings for adding empty lines
function! s:AddLines(before)
  let cnt = (v:count>0) ? v:count : 1
  call append(line('.')-a:before, repeat([''], cnt))
  silent! call repeat#set((a:before ? '[ ' : '] '), cnt)
endf

" configure completion to complete in command window
function! s:init_cmdwin()
    " unmap <tab>
    iunmap <buffer> <Tab>
    nunmap <buffer> <Tab>

    " leave command window quicker
    nnoremap <buffer><silent> q :<C-u>quit<CR>
    nnoremap <buffer><silent> <tab> :<C-u>quit<CR>

    " Movement within 'ins-completion-menu'
    inoremap <buffer><expr><silent> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
    inoremap <buffer><expr><silent> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"
    " use tab to cycle
    inoremap <buffer><expr><silent> <tab> pumvisible() ? "\<c-y>" : "\<tab>"
    " get normal <CR> behaviour
    inoremap <buffer><expr><silent> <cr>  pumvisible() ? "\<c-e>\<cr>" : "\<cr>"
    
    startinsert!
endfunction

" Custom mappings for the unite buffer
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
    " sometimes its left turned on and messes input
    set nopaste

    imap <buffer> <esc> <c-u><bs>

    " go backwards in path
    imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
    imap <buffer> <CR>  <Plug>(unite_do_default_action))
    nmap <buffer> <C-f> <Plug>(unite_toggle_auto_preview)

    " move between lines
    imap <buffer> <TAB> <Plug>(unite_select_next_line)
    imap <buffer> <C-j> <Plug>(unite_select_next_line)
    imap <buffer> <C-k> <Plug>(unite_select_previous_line)
endfunction

" }}}
