" Sneak
let g:sneak#label = 1
let g:sneak#target_labels = "abcdefghijklmnopqrstuvwxyz"
let g:sneak#s_next = 1
let g:sneak#use_ic_scs = 1
let g:sneak#prompt = 'STREAK>>>'

nmap <space>j <Plug>Sneak_s
nmap <space>k <Plug>Sneak_S
nmap <c-f> <Plug>Sneak_s
nmap s <Plug>Sneak_s
nmap S <Plug>Sneak_S
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

" FZF
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_preview_window = ['right:50%:hidden', 'ctrl-/']
let g:fzf_history_dir = '~/.local/share/fzf-history'
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
let $FZF_DEFAULT_OPTS = '--reverse --bind ctrl-k:up,ctrl-j:down'

" fix for line numbers in FZF window
au TermOpen * setlocal nonumber norelativenumber

" Helper to avoid path issues and start in input mode.
function! s:WorkSink(line)
  execute 'Files ~/work/' .. a:line
endfunction

function! s:WorkSearch()
  call fzf#run(fzf#wrap({
  \  'source': 'ls ~/work',
  \  'dir': '~/work',
  \  'sink': function('s:WorkSink')
  \}))
endfunction

function! s:PanaceaFunc()
  if empty(GetGitRoot())
    call s:WorkSearch()
  else
    call fzf#vim#gitfiles('')
  endif
endfunction

" Search with Ag but from repo root.
function! GitRootAg(input)
  exec 'cd' GetGitRoot()
  exec 'Ag! ' . a:input
endfunction

command!          Work      call s:WorkSearch()
command!          Panacea   call s:PanaceaFunc()
command! -nargs=? GitRootAg call GitRootAg(<q-args>)
command! -nargs=? AG        call GitRootAg(<q-args>)
command! -bang -nargs=? -complete=dir Ag
  \ call fzf#vim#ag(<q-args>, fzf#vim#with_preview('right'), <bang>0)

nnoremap <tab>              :Panacea<CR>
nnoremap <c-a>              :Work<CR>
nnoremap <c-s>              :Files ~/nixos<CR>
nnoremap <c-q>              :Files ~/dotfiles<CR>
nnoremap <c-space>          :History<CR>
nnoremap <c-b>              :Buffers<CR>
nnoremap <leader><leader>b  :Buffers<CR>
nnoremap <leader><leader>h  :History<CR>
nnoremap <leader><leader>m  :Marks<CR>
nnoremap <leader><leader>f  :Files<CR>
nnoremap <leader><leader>g  :GFiles<CR>
nnoremap <leader><leader>c  :Commits<CR>
nnoremap <leader><leader>l  :Lines<CR>
nnoremap <leader><leader>a  :GitRootAg<space>
nnoremap <leader><leader>A  :GitRootAg<space><c-r>=expand("<cword>")<CR><CR>
