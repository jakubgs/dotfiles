nnoremap <leader>gr :Gread<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gw :Gwrite<CR>
nnoremap <leader>ga :Gwrite<CR>
nnoremap <leader>gc :Gcommit -s -v -q -n<CR>
nnoremap <leader>gt :Gcommit -s -v -q -n -- %:p<CR>
nnoremap <leader>gC :Gcommit -s -v -q -n --amend<CR>
nnoremap <leader>gT :Gcommit -s -v -q -n --amend -- %:p<CR>
nnoremap <leader>gd :Gvdiff<CR>
nnoremap <leader>ge :Gedit<CR>
nnoremap <leader>gu :Git reset "%:p"<CR><CR>
nnoremap <leader>gl :Gitv --all<CR>
nnoremap <leader>gp :Ggrep<Space>
nnoremap <leader>gm :Gmove<Space>
nnoremap <leader>gB :Gblame<CR>
nnoremap <leader>gw :Gbrowse<CR>
nnoremap <leader>gW :Gbrowse!<CR>
vnoremap <leader>gw :Gbrowse<CR>
vnoremap <leader>gW :Gbrowse!<CR>
nnoremap <leader>go :Git checkout<Space>
nnoremap <leader>gf  :Dispatch! git fetch --all<CR>
nnoremap <leader>gps :Dispatch! git push<CR>
nnoremap <leader>gpS :Dispatch! git push --force<CR>
nnoremap <leader>gpl :Dispatch! git pull<CR>

nnoremap <leader>gv :execute('Gitv '.expand('%:p'))<CR>
nnoremap <leader>gV :execute('Gitv! '.expand('%:p'))<CR>

nnoremap <leader>gSs :Git status <bar>
                    \ if confirm('Do you want to stash changes?') <bar>
                        \ Git stash --include-untracked <bar>
                    \ endif<CR><CR>
nnoremap <leader>gSa :Git stash list --date=local <bar>
                    \ if confirm('Apply stash@{0}?') <bar>
                        \ Git stash apply <bar>
                    \ endif<CR><CR>
