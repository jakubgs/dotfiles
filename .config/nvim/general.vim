" Debugging server
"call serverstart($NVIM_LISTEN_ADDRESS)

syntax on                         " File-type highlighting
filetype on                       " enable file type detection
filetype plugin on                " loading of plugin files for all formats
filetype indent on                " loading of indent files for all formats

" Buffers
set autochdir                     " Automatically changing working dir
set splitright                    " new windows right to the current
set clipboard=unnamedplus         " paste the clipboard to unnamed register
set hidden                        " buffer change, more undo

" Visual
set list                          " show tabs and newlines
set cursorline                    " highlight the current line
set number                        " show current line number
set relativenumber                " distance from the current line
set showmatch                     " show matching brackets
set scrolloff=3                   " number of lies vim won't scroll below
set nofoldenable                  " disable folding by default
set nowrap                        " text wrapping

" Formatting settings
set expandtab                     " use spaces instead of tabs
set tabstop=4                     " spaces in <tab>
set softtabstop=4                 " spaces in <tab> when editing
set shiftwidth=4                  " spaces for each step of (auto)indendt

" Search
set ignorecase                    " ignore case
set smartcase                     " unless upper case used
set iskeyword+=$,@,%              " not word dividers
set iskeyword-=_,.                " word dividers

" Saves lives
set undofile                      " Save undo's after file closes
set undodir=~/.config/nvim/undo// " where to save undo histories
set undolevels=100                " How many undos
set undoreload=1000               " number of lines to save for undo

if has("multi_byte")
    set fillchars=vert:│,fold:-   " smooth windows splits
    set listchars=tab:▸\ ,eol:¬   " visible chars for tabs and EOLs
endif

" NetRW file browser style
let g:netrw_liststyle = 4

" Return to last edit position when opening files (You want this!)
augroup saveposition
    autocmd!
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
augroup END

" Auto resize splits when vim window size changes.
augroup autoresize
    autocmd VimResized * silent! exe "normal! \<c-w>="
augroup END

" save the file as root (tee must be addedd as NOPASSWD to sudoers)
command! -bar -nargs=0 Sw :silent exe 'write !sudo tee % >/dev/null' | silent edit!
