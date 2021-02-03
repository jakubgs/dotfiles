" Get absolute path of root of current Git repo
function! GetGitRoot()
  let root = split(system('git rev-parse --show-toplevel'), '\n')[0]
  return v:shell_error ? '' : root
endfunction

" Copy file path to clipboard
function! CopyPath(relative)
    let l:path = expand("%:p")
    if a:relative
        let l:path = substitute(path, GetGitRoot().'/', '', '')
    endif
    echo "Copying: " . l:path
    " save to both clipboards
    let @* = l:path
    let @+ = l:path
endfunction
