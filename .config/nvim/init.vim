if !has('nvim')
  set encoding=utf8
endif
scriptencoding utf8
"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif


" Required:
set runtimepath+=/home/satori/.config/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state ('/home/satori/.config/dein')
  call dein#begin('/home/satori/.config/dein')

  " Let dein manage dein
  " Required:
  call dein#add('/home/satori/.config/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
  call dein#add('easymotion/vim-easymotion')
  " call dein#add('Shougo/neocomplete.vim')
  " call dein#add('Shougo/neosnippet.vim')
  " call dein#add('Shougo/neosnippet-snippets')

  " You can specify revision/branch/tag.
  " call dein#add('Shougo/vimshell', { 'rev': '3787e5' })

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

"End dein Scripts-------------------------
" Prueba de neosnippet.
"
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
nnoremap ; :
nnoremap : :! clear && 
nnoremap í :! clear && lilyterm<cr>
inoremap , <ESC>
nnoremap z zA
nnoremap <C-h> :tabp<CR>
nnoremap <C-l> :tabn<CR>
cmap qq q!
cmap ww w !sudo tee %
set expandtab tabstop=4 shiftwidth=4 softtabstop=4
set scrolloff=5
set number relativenumber
set ignorecase smartcase
set pastetoggle=<F2>
set autochdir
set mouse=a
set colorcolumn=80
function OnHTML ()
    inoremap Á &Aacute;
    inoremap É &Eacute;
    inoremap Í &Iacute;
    inoremap Ó &Oacute;
    inoremap Ú &Uacute;
    inoremap Ü &Uuml;
    inoremap Ñ &Ntilde;
    inoremap á &aacute;
    inoremap é &eacute;
    inoremap í &iacute;
    inoremap ó &oacute;
    inoremap ú &uacute;
    inoremap ü &uuml;
    inoremap ñ &ntilde;
endfunction
autocmd FileType html :call OnHTML()
autocmd FileType php :call OnHTML()
" File navigation
let g:netrw_liststyle = 3
let g:netrw_banner = 0
" Open directory tree with ñ
nnoremap ñ :tabe .<CR>
" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=% 

" Indent correctly on paste " Need to test if it really works.
nnoremap <leader>p p
nnoremap <leader>P P
nnoremap p p'[v']=
nnoremap P P'[v']= 
" I hate ex mode
map Q <Nop>

" Easymotion:
let g:EasyMotion_do_mapping = 0 " Disable default mappings
nmap s <Plug>(easymotion-overwin-f)
" nmap s <Plug>(easymotion-overwin-f2)
let g:EasyMotion_smartcase = 1
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
nmap f <Plug>(easymotion-bd-w)
vmap f <Plug>(easymotion-bd-w)
" Highlight when using 'f'
hi EasyMotionShade ctermbg=none ctermfg=blue
hi EasyMotionTarget2Second ctermbg=none ctermfg=lightred 
