if !has('nvim')
  set encoding=utf8
  set ttymouse=sgr
  " Replace file contents with the clipboard
  nnoremap ö ggdG:r !wl-paste<CR>
  set encoding=utf8
  set mouse=a
else
  " Neovim does not need wl-paste
  nnoremap ö ggdG"+p
endif
scriptencoding utf8

nnoremap ; :
nnoremap : :! clear && 
nnoremap í :! clear && $TERMINAL &<CR><CR>
nnoremap ú :%y+<CR>
nnoremap <C-h> :tabp<CR>
nnoremap <C-l> :tabn<CR>
" Replace file contents with clipboard
cmap qq q!
cmap ww w !sudo tee %
set hlsearch
set incsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
set expandtab tabstop=2 shiftwidth=2 softtabstop=2
set scrolloff=5
set number relativenumber
set ignorecase smartcase
set pastetoggle=<F2>
set autochdir

set termguicolors
set colorcolumn=80

filetype plugin on
filetype indent on

" Black foreground on white background
highlight Normal guibg=#FFFFFF guifg=#000000
highlight ColorColumn ctermbg=7
let g:netrw_liststyle = 3
let g:netrw_banner = 0
nnoremap ñ :tabe .<CR>
nnoremap µ :tabe<CR>:MRU<CR>

" Return to last edit position when opening files
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

nnoremap ; :
nnoremap : :! clear && 
nnoremap í :! clear && $TERMINAL &<CR><CR>
nnoremap ú :%y+<CR>
nnoremap <C-h> :tabp<CR>
nnoremap <C-l> :tabn<CR>
" Easier foce close
cmap qq q!
" Useful when saving a file that requires supeuser access
cmap ww w !sudo tee %
set hlsearch
set incsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
set expandtab tabstop=2 shiftwidth=2 softtabstop=2
set scrolloff=5
set number relativenumber
set ignorecase smartcase
set pastetoggle=<F2>
set autochdir
set mouse=a

set termguicolors
set colorcolumn=80

filetype plugin on
filetype indent on

" I hate ex mode.
map Q <Nop>

" Easymotion:
let g:EasyMotion_do_mapping = 0 " Disable default mappings
" nmap s <Plug>(easymotion-overwin-f2)
let g:EasyMotion_smartcase = 1
nmap s <Plug>(easymotion-bd-w)
vmap s <Plug>(easymotion-bd-w)
" Highlight when using 'f'
hi EasyMotionShade ctermbg=none ctermfg=blue
hi EasyMotionTarget2Second ctermbg=none ctermfg=black
hi EasyMotionTarget2First ctermbg=none ctermfg=red
syntax on

lua << EOF
require('catppuccin').setup({
    -- Your configuration comes here
    -- or leave it empty to use the default settings
})
vim.cmd('colorscheme catppuccin')
EOF
