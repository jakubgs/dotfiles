let g:jellybeans_overrides = {
\    'background': { 'ctermbg': 'NONE', '256ctermbg': 'NONE', 'guibg': 'NONE' },
\}
set background=dark
colorscheme jellybeans

" Make visual selection match lightline
hi! link Visual LightlineLeft_visual_0
hi! link Cursor LightlineLeft_normal_0
