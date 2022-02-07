" Deoplete
set completeopt=menu,preview
let g:deoplete#sources#go#gocode_binary = '/home/sochan/.nix-profile/bin/gocode'
let g:deoplete#sources#go#gopls_binary = '/home/sochan/.nix-profile/bin/gopls'
let g:deoplete#sources#ternjs#tern_bin = '/usr/local/bin/tern'
let g:deoplete#sources#ternjs#timeout = 1
let g:deoplete#sources#ternjs#docs = 1
let g:deoplete#enable_at_startup = 1

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

call deoplete#custom#option({
  \  'auto_complete_delay': 0,
  \  'smart_case': v:true,
  \})

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ deoplete#manual_complete()
