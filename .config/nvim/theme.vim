let g:jellybeans_overrides = {
\    'background': { 'ctermbg': 'NONE', '256ctermbg': 'NONE', 'guibg': 'NONE' },
\}
set background=dark
colorscheme jellybeans

" Make visual selection match lightline
hi! link Visual LightlineLeft_visual_0
hi! link Cursor LightlineLeft_normal_0

" Highlight trailing whitespace in normal mode
autocmd InsertLeave * hi! ExtraWhitespace ctermbg=red guibg=red
autocmd InsertEnter * hi! ExtraWhitespace NONE
match ExtraWhitespace /\s\+$/
