"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/home/satori/.config/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/home/satori/.config/dein')
  call dein#begin('/home/satori/.config/dein')

  " Let dein manage dein
  " Required:
  call dein#add('/home/satori/.config/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
  call dein#add('Shougo/neocomplete.vim')
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')

  " You can specify revision/branch/tag.
  call dein#add('Shougo/vimshell', { 'rev': '3787e5' })

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
inoremap jk <ESC>
nnoremap z zA
cmap qq q!
cmap ww w !sudo tee %
set expandtab tabstop=4 shiftwidth=4 softtabstop=4
set number relativenumber
set ignorecase smartcase
set pastetoggle=<F2>
set autochdir
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
