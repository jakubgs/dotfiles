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

" Highlight trailing whitespace and fix it
hi ExtraWhitespace ctermbg=darkred guibg=darkred
let g:better_whitespace_enabled=1
let g:strip_whitelines_at_eof=1
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0
