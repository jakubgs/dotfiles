" My own version of powerline that's not 400 lines long {{{2
let g:last_mode = ''
function! Mode()
    let l:mode = mode()

    if l:mode !=# g:last_mode
        let g:last_mode = l:mode

        " mode
        hi User2 guifg=#005f00 guibg=#afd700 gui=BOLD ctermfg=22 ctermbg=190 cterm=BOLD
        " file depth
        hi User3 guifg=#afd700 guibg=#414243 ctermfg=255 ctermbg=238 cterm=bold
        " file info
        hi User4 guifg=#989c88 guibg=#151515 ctermfg=241 ctermbg=234
        " line:row
        hi User5 guifg=#4e4e4e guibg=#FFFFFF gui=bold ctermfg=239 ctermbg=255 cterm=bold
        " git status
        hi User6 guifg=#a8bcbc guibg=#585858 ctermfg=255 ctermbg=238
        " file name
        hi User7 guifg=#FFFFFF guibg=#585858 gui=bold ctermfg=255 ctermbg=238 cterm=bold

        if l:mode ==# 'n'
            hi User3 guifg=#afd700 ctermfg=190
        elseif l:mode ==# "i"
            hi User2 guibg=#ffffff guifg=#005f87 ctermbg=231 ctermfg=24
            hi User3 guifg=#ffffff guibg=#0087af ctermbg=4
            hi User4 guifg=#60d2f5 guibg=#005f87 ctermfg=117 ctermbg=24
            hi User5 guibg=#87d7ff ctermfg=27 ctermbg=117
            hi User6 guifg=#87d7ff guibg=#0087af ctermfg=117 ctermbg=4
            hi User7 guibg=#0087af ctermbg=4
        elseif l:mode ==# "R"
            hi User2 guifg=#FFFFFF guibg=#df0000 ctermfg=255 ctermbg=160
        elseif l:mode ==? "v" || l:mode ==# ""
            hi User2 guifg=#4e4e4e guibg=#ffaf00 ctermfg=239 ctermbg=214
        elseif l:mode ==# ""
            hi User2 guibg=#FFFFFF
        endif
    endif
    
    if l:mode ==# "n"
      return "\  NORMAL "
    elseif l:mode ==# "i"
      return "\  INSERT "
    elseif l:mode ==# "R"
      return "\  RPLACE "
    elseif l:mode ==# "v"
      return "\  VISUAL "
    elseif l:mode ==# "V"
      return "\  V·LINE "
    elseif l:mode ==# ""
      return "\  V·BLCK "
    else
      return l:mode
    endif
endfunction

function! GitStatus()
    let result = split(system('git status --porcelain '.shellescape(expand('%:t'))." 2>/dev/null|awk '{print $1}'"))

    if len(result) > 0
        return join(result).' '
    else
        return ''
    endif
endfunction

set statusline=%2*%{Mode()}
set statusline+=%6*%{strlen(fugitive#statusline())>0?'\ ':''}
set statusline+=%{matchstr(fugitive#statusline(),'(\\zs.*\\ze)')}
set statusline+=%{strlen(fugitive#statusline())>0?'\ \ >\ ':'\ '}
set statusline+=%7*%f%<\ %{&ro?'>':''}
set statusline+=%{GitStatus()}
set statusline+=%{&mod?'+':''}
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%4*%=
set statusline+=%4*\ %{strlen(&fileformat)>0?&fileformat.'\ <\ ':''}
set statusline+=%{strlen(&fileencoding)>0?&fileencoding.'\ <\ ':''}
set statusline+=%{strlen(&filetype)>0?&filetype.'\ ':''}
set statusline+=%3*\ %p%%\ |
set statusline+=%5*\ %l:%c\ |

" Current Buffer statusline
let g:CBstatusline=&g:statusline
" Not Current statusline
let g:NCstatusline="%6*%f%< %{&ro?'>':''}%4*%=%4*\ %{strlen(&fileformat)>0?&fileformat.'\ <\ ':''}%{strlen(&fileencoding)>0?&fileencoding.'\ <\ ':''}%{strlen(&filetype)>0?&filetype.'\ ':''}%3* %p%% %6* %l:%c "

au WinEnter * let&l:statusline = g:CBstatusline
au WinLeave * let&l:statusline = g:NCstatusline 
" }}}2
