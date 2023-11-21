" easier resizing
nnoremap <up>    :resize -5<CR>
nnoremap <down>  :resize +5<CR>
nnoremap <left>  :vert resize -5<CR>
nnoremap <right> :vert resize +5<CR>

" Changing leader
let mapleader = " "
let maplocalleader = "\\"

" easier access to commands
nnoremap ; :<c-f>
nnoremap : ;
nnoremap q; :
xnoremap ; :<c-f>
xnoremap : ;
xnoremap q; :

" reselect visual block after indent/outdent
xnoremap < <gv
xnoremap > >gv

" search visually selected text
vnoremap * y/\V<C-R>=escape(@",'/\')<CR><CR>

" make last typed word uppercase
inoremap <c-u> <esc>viwUea

" for moving in wrapped lines
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" easier opening of links
nnoremap K <Plug>NetrwBrowseX

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

" copy to clipboard with ctrl+c in visual mode
xnoremap <c-c> "*y:call system('xclip -i -selection clipboard', @*)<CR>

nnoremap <leader>p :call CopyPath(0)<CR>
nnoremap <leader>P :call CopyPath(1)<CR>

" close buffer but leave active pane open
nnoremap <silent> <leader>q :bprevious<bar>bd! #<CR>
nnoremap <silent> <leader>Q :<CR>

" Edit .vimrc and refresh configuration
nnoremap <leader>r :source ~/dotfiles/.config/nvim/init.vim<CR>
nnoremap <leader>R :vsp ~/dotfiles/.config/nvim/init.vim<CR>
nnoremap <leader>T :vsp ~/work/jakubgs-notes/todo.md<CR>

" Checkbox
nnoremap <leader>t :ToggleCB<CR>

" Goyo plugin
nnoremap <F10> :Goyo<CR>
let g:goyo_width = 120
