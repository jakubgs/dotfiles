" Sneak
let g:sneak#label = 1
let g:sneak#target_labels = "abcdefghijklmnopqrstuvwxyz"
let g:sneak#s_next = 1
let g:sneak#use_ic_scs = 1
let g:sneak#prompt = 'STREAK>>>'

nmap <space>j <Plug>Sneak_s
nmap <space>k <Plug>Sneak_S
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

" FZF
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_preview_window = []
let g:fzf_history_dir = '~/.local/share/fzf-history'
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

function! PanaceaFunc()
  if empty(GetGitRoot())
    call s:WorkSearch()
  else
    call fzf#vim#gitfiles('')
  endif
endfunction

command! Work    call s:WorkSearch()
command! Panacea call PanaceaFunc()

nnoremap <c-i>              :Panacea<CR>
nnoremap <c-a>              :Work<CR>
nnoremap <c-space>          :History<CR>
nnoremap <c-b>              :History<CR>
nnoremap <space><space>     :History<CR>
nnoremap <leader><leader>h  :History<CR>
nnoremap <leader><leader>m  :Marks<CR>
nnoremap <leader><leader>f  :Files<CR>
nnoremap <leader><leader>g  :GFiles<CR>
nnoremap <leader><leader>c  :Commits<CR>
nnoremap <leader><leader>l  :Lines<CR>
nnoremap <leader><leader>a  :Ag<leader>
