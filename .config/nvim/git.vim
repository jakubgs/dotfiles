" Better Gllog format
let g:fugitive_summary_format = "%<(16,trunc)%an || %s"

nnoremap <leader>gs :Git<CR>
nnoremap <leader>gg :Git<CR>
nnoremap <leader>gr :Gread<CR>
nnoremap <leader>gw :Gwrite<CR>
nnoremap <leader>ga :Gwrite<CR>
nnoremap <leader>gc :Git commit -s -v -q -n<CR>
nnoremap <leader>gt :Git commit -s -v -q -n -- %:P<CR>
nnoremap <leader>gC :Git commit -s -v -q -n --amend<CR>
nnoremap <leader>gT :Git commit -s -v -q -n --amend -- %:P<CR>
nnoremap <leader>gd :Gvdiff<CR>
nnoremap <leader>ge :Gedit<CR>
nnoremap <leader>gu :Git reset "%:p"<CR><CR>
nnoremap <leader>gl :GV<CR>
nnoremap <leader>gL :GV?<CR>
nnoremap <leader>gp :Ggrep<Space>
nnoremap <leader>gm :Gmove<Space>
nnoremap <leader>gB :Git blame<CR>
nnoremap <leader>gw :GBrowse<CR>
nnoremap <leader>gW :GBrowse!<CR>
vnoremap <leader>gw :GBrowse<CR>
vnoremap <leader>gW :GBrowse!<CR>
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
