" Author: Jakub Sokołowski <jakub@gsokolowski.pl>
" Source: https://github.com/jakubgs/dotfiles

" Plugin management {{{

" auto-install vim-plug                                                                                                                
if empty(glob('~/.config/nvim/autoload/plug.vim'))                                                                                    
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall                                                                                                      
endif  
call plug#begin('~/.config/nvim/bundle')

let g:ale_completion_enabled = 1

" Misc plugins
Plug 'dbakker/vim-projectroot'
Plug 'sotte/presenting.vim'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-vinegar'
Plug 'xolox/vim-misc'
Plug 'bruno-/vim-man'
Plug 'metakirby5/codi.vim'
Plug 'junegunn/goyo.vim'
Plug 'justinmk/vim-sneak'
" Text manipulation
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tommcdo/vim-exchange'
Plug 'godlygeek/tabular'
Plug 'jkramer/vim-checkbox'
" Git plugins
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'gregsexton/gitv'
Plug 'airblade/vim-gitgutter'
" Searching Plugins
Plug 'Shougo/denite.nvim'
Plug 'Shougo/neomru.vim'
" Completion
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/neco-vim'
Plug 'deoplete-plugins/deoplete-go', { 'do': 'make'}
Plug 'carlitux/deoplete-ternjs', { 'do': 'yarn global add tern' }
Plug 'deoplete-plugins/deoplete-jedi'
" Style
Plug 'nanotech/jellybeans.vim'
Plug 'itchyny/lightline.vim'

" Syntax
Plug 'robbles/logstash.vim',            { 'for': 'logstash' }
Plug 'pearofducks/ansible-vim',         { 'for': 'yaml.ansible' }
Plug 'martinda/Jenkinsfile-vim-syntax', { 'for': 'Jenkinsfile' }
Plug 'hashivim/vim-terraform',          { 'for': 'terraform' }
Plug 'LaTeX-Box-Team/LaTeX-Box',        { 'for': 'latex' }
Plug 'LnL7/vim-nix',                    { 'for': 'nix' }
Plug 'lepture/vim-jinja',               { 'for': 'jinja' }
Plug 'fatih/vim-go',                    { 'for': 'go' }
Plug 'sebdah/vim-delve',                { 'for': 'go' }
Plug 'pangloss/vim-javascript',         { 'for': 'javascript' }
Plug 'pangloss/vim-javascript',         { 'for': 'javascript' }
Plug 'moll/vim-node',                   { 'for': 'javascript' }
Plug 'tell-k/vim-autopep8',             { 'for': 'python' }
Plug 'hynek/vim-python-pep8-indent',    { 'for': 'python' }
Plug 'bfredl/nvim-ipy',                 { 'for': 'python' }

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
set nofoldenable                  " disable folding by default
set lazyredraw                    " faster macros processing
set visualbell                    " tell vim to shut up
set virtualedit=block             " allow to go beyond blank space in visual m.
set scrolloff=3                   " number of lies vim won't scroll below
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

" Goyo
let g:goyo_width = 110

" Ansible
let g:ansible_attribute_highlight = 'ab'
let g:ansible_name_highlight = 'd'
let g:ansible_extra_keywords_highlight = 1

" Markdown
let g:markdown_syntax_conceal = 1

let g:terraform_align = 1
let g:terraform_fold_sections = 1

let g:jsx_ext_required = 0

" Surround
" /* TEXT */ comments
let g:surround_42 = "/* \r */"

" Lightline
let g:lightline = {
\  'colorscheme': 'powerline',
\  'active': {
\    'left': [ [ 'mode', 'paste' ], [ 'readonly', 'absolutepath', 'modified' ] ],
\  }
\}

" Deoplete
set completeopt=menu,preview
let g:deoplete#sources#go#gocode_binary = '/home/sochan/go/bin/gocode'
let g:deoplete#sources#ternjs#tern_bin = '/usr/local/bin/tern'
let g:deoplete#sources#ternjs#timeout = 1
let g:deoplete#sources#ternjs#docs = 1
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option({
\  'auto_complete_delay': 0,
\  'smart_case': v:true,
\})
inoremap <silent><expr> <TAB>
\ pumvisible() ? "\<C-n>" :
\ <SID>check_back_space() ? "\<TAB>" :
\ deoplete#manual_complete()
function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}

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

" How long in milliseconds it takes for plugin refresh
set updatetime=1000

" by default start in home directory
let g:projectroot = '~/work/'

" Gitv
let g:Gitv_CommitStep = &lines
let g:Gitv_DoNotMapCtrlKey = 1
let g:Gitv_WipeAllOnClose = 1
let g:Gitv_TruncateCommitSubjects = 1

" Denite

" Define mappings
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>    denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d       denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p       denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q       denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc>   denite#do_map('quit')
  nnoremap <silent><buffer><expr> <C-c>   denite#do_map('quit')
  nnoremap <silent><buffer><expr> i       denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space> denite#do_map('toggle_select').'j'
endfunction

autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  " disable deoplete in denite filter
  call deoplete#custom#buffer_option('auto_complete', v:false)
  " quit both windows
  inoremap <silent><buffer><expr>  <Esc>  denite#do_map('quit')
  inoremap <silent><buffer><expr>  <c-o>  denite#do_map('quit')
  inoremap <silent><buffer><expr>  <c-c>  denite#do_map('quit')
  " some more cool stuff
  inoremap <silent><buffer><expr>  <CR>   denite#do_map('do_action')
  inoremap <silent><buffer><expr>  <C-p>  denite#do_map('do_action', 'preview')
  inoremap <silent><buffer><expr>  <C-l>  denite#do_map('redraw')
  " move cursor in suggestions list
  inoremap <silent><buffer>        <C-j>  <Esc><C-w>p:call cursor(line('.')+1,0)<CR><C-w>pA
  inoremap <silent><buffer>        <C-k>  <Esc><C-w>p:call cursor(line('.')-1,0)<CR><C-w>pA
  inoremap <silent><buffer>        <C-d>  <Esc><C-w>p:call cursor(line('.')+30,0)<CR><C-w>pA
  inoremap <silent><buffer>        <C-u>  <Esc><C-w>p:call cursor(line('.')-30,0)<CR><C-w>pA
endfunction

call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'default_opts', ['--vimgrep'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" Change file/rec command.
call denite#custom#var('file/rec', 'command', [
\ 'ag', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', ''
\])

" Change matchers.
call denite#custom#source('_', 'matchers', [
\ 'matcher/substring',
\ 'matcher/ignore_current_buffer',
\])

" Change default action.
call denite#custom#option('_', {
\ 'start_filter': 1,
\ 'cache_threshold': 6000,
\ 'cursor_pos': '0',
\ 'split': 'no',
\ 'filter_split_direction': 'aboveleft',
\ 'statusline': 1,
\})

let g:neomru#file_mru_limit = 500
let g:neomru#directory_mru_limit = 500

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

" }}}
" Key mappings - General {{{

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
nnoremap <space>p :call CopyPath(0)<CR>
nnoremap <space>P :call CopyPath(1)<CR>

" execute current line in vim
nnoremap <space>v :execute getline(".")<cr>;w

" put last searched items into QuickFix window
nnoremap <space>/ :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

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

" MASTER STROKE - Repeat last command
nnoremap <c-space> @:<CR>

" Dispatch a command
nnoremap <space>d :Dispatch!<space>

" }}}
" Key mappings - Codi {{{

nnoremap <space>cc :Codi<CR>
nnoremap <space>cd :Codi!<CR>
nnoremap <space>ct :Codi!!<CR>
nnoremap <space>cu :CodiUpdate<CR>
nnoremap <space>cp :Codi python<CR>
nnoremap <space>cr :Codi ruby<CR>
nnoremap <space>cj :Codi javascript<CR>

" }}}
" Key mappings - Denite {{{

nnoremap <c-i>     :execute('Denite buffer file/rec -path='.g:projectroot.' file_mru')<CR>
nnoremap <space>ub :Denite buffer<CR>
nnoremap <space>uc :Denite command<CR>
nnoremap <space>ug :execute('Denite grep -path='.g:projectroot)<CR>
nnoremap <space>uG :execute('Denite grep -path='.g:projectroot.'::!')<CR>
nnoremap <space>uh :Denite help<CR>
nnoremap <space>uj :Denite jump<CR>
nnoremap <space>ul :Denite line<CR>
nnoremap <space>um :Denite file_mru<CR>
nnoremap <space>ur :Denite register<CR>
nnoremap <space>us :Denite source<CR>
nnoremap <space>ut :Denite tag<CR>
nnoremap <space>uu :Denite file<CR>
nnoremap <space>uW :Denite file -path=~/work/<CR>
nnoremap <space>uH :Denite file -path=~/<CR>
nnoremap <space>uD :Denite file/rec -path=~/dotfiles/<CR>
nnoremap <space>uC :Denite menu:configs<CR>
nnoremap <space>up :execute('Denite file/rec -path='.g:projectroot)<CR>
nnoremap <space>uw :execute('Denite file -path='.g:projectroot)<CR>
" search openned buffers
nnoremap <space><space> :Denite buffer<CR>
" grep currently searched word
nnoremap <space>*  :call GrepSearchedWord()<CR>

" Key mappings - Git {{{

nnoremap <space>gr :Gread<CR>
nnoremap <space>gs :Gstatus<CR>
nnoremap <space>gw :Gwrite<CR>
nnoremap <space>ga :Gwrite<CR>
nnoremap <space>gc :Gcommit -s -v -q -n<CR>
nnoremap <space>gt :Gcommit -s -v -q -n -- %:p<CR>
nnoremap <space>gC :Gcommit -s -v -q -n --amend<CR>
nnoremap <space>gT :Gcommit -s -v -q -n --amend -- %:p<CR>
nnoremap <space>gd :Gvdiff<CR>
nnoremap <space>ge :Gedit<CR>
nnoremap <space>gu :Git reset "%:p"<CR><CR>
nnoremap <space>gl :Gitv --all<CR>
nnoremap <space>gp :Ggrep<Space>
nnoremap <space>gm :Gmove<Space>
nnoremap <space>gB :Gblame<CR>
nnoremap <space>gw :Gbrowse<CR>
nnoremap <space>gW :Gbrowse!<CR>
vnoremap <space>gw :Gbrowse<CR>
vnoremap <space>gW :Gbrowse!<CR>
nnoremap <space>go :Git checkout<Space>
nnoremap <space>gg :GitGutterToggle<CR>
nnoremap <space>gf  :Dispatch! git fetch --all<CR>
nnoremap <space>gps :Dispatch! git push<CR>
nnoremap <space>gpS :Dispatch! git push --force<CR>
nnoremap <space>gpl :Dispatch! git pull<CR>

nnoremap <space>gv :execute('Gitv '.expand('%:p'))<CR>
nnoremap <space>gV :execute('Gitv! '.expand('%:p'))<CR>

nnoremap <space>gSs :Git status <bar>
                    \ if confirm('Do you want to stash changes?') <bar>
                        \ Git stash --include-untracked <bar>
                    \ endif<CR><CR>
nnoremap <space>gSa :Git stash list --date=local <bar>
                    \ if confirm('Apply stash@{0}?') <bar>
                        \ Git stash apply <bar>
                    \ endif<CR><CR>

" }}}
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
" Key mappings - Fxx {{{

nnoremap <F11> :Goyo<CR>
nnoremap <F10> :setlocal relativenumber!<CR>
nnoremap <F9>  :setlocal number!<CR>
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

augroup autoresize
    autocmd VimResized * silent! exe "normal! \<c-w>="
augroup END

augroup detect_projectroot
    autocmd!
    autocmd BufEnter * silent! call DetectProjectRoot()
augroup END

" }}}
" Functions {{{

" I want to avoid project root being just home.
" Too many files to search.
function! DetectProjectRoot()
    let g:projectroot = projectroot#guess()
    if g:projectroot == expand('~/')
        let g:projectroot = expand('~/') . '/work'
    endif
endfunction

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

function! CopyPath(relative)
    let l:path = expand("%:p")
    if a:relative
        let l:path = substitute(path, projectroot#guess().'/', '', '')
    endif
    echo "Copying: " . l:path
    " save to both clipboards
    let @* = l:path
    let @+ = l:path
endfunction

function! GrepSearchedWord()
  let search =  getreg('/')
  " translate vim regular expression to perl regular expression.
  let search = substitute(search, '\(\\<\|\\>\)', '', 'g')
  let search = substitute(search, ':', '\\:', 'g')
  execute('Denite grep:'.g:projectroot.'::'.search)
endfunction

" }}}
