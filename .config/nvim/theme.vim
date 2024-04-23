let g:jellybeans_overrides = {
\    'background': { 'ctermbg': 'NONE', '256ctermbg': 'NONE', 'guibg': 'NONE' },
\}
set background=dark
colorscheme jellybeans

" Make visual selection match lightline
hi! link Visual LightlineLeft_visual_0
hi! link Cursor LightlineLeft_normal_0

" Sneak Highlights
hi! link Sneak Cursor
hi! link SneakLabel TabLineSel

" Highlight trailing whitespace in normal mode
autocmd InsertLeave * hi! ExtraWhitespace ctermbg=red guibg=red
autocmd InsertEnter * hi! ExtraWhitespace NONE
autocmd FileType fzf  hi! ExtraWhitespace NONE
match ExtraWhitespace /\s\+$/
