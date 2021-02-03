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

augroup MyAutoCmd
    autocmd!
    autocmd CmdwinEnter * silent! call s:init_cmdwin()
augroup END
