let SessionLoad = 1
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/code/5mincode
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +2 _includes/image
badd +8 _drafts/2018-09-02-generating-pythagoras-trees-using-SFML.md
badd +1 term://.//4587:/bin/bash
badd +28 ~/.vim/vimrc
badd +1 _posts/2018-09-01-welcome-to-jekyll.md
badd +22 _posts/2018-09-02-generating-pythagoras-trees-using-SFML.md
badd +0 term
badd +5 term://.//6128:/bin/bash
badd +1 git
badd +0 term://.//6719:/bin/bash
argglobal
silent! argdel *
$argadd ~/code/5mincode/
$argadd _drafts/2018-09-02-generating-pythagoras-trees-using-SFML.md
$argadd _drafts/2018-09-02-generating-pythagoras-trees-using-SFML.md
$argadd _drafts/2018-09-02-generating-pythagoras-trees-using-SFML.md
set stal=2
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=1 winminwidth=1 winheight=1 winwidth=1
argglobal
if bufexists('term://.//4587:/bin/bash') | buffer term://.//4587:/bin/bash | else | edit term://.//4587:/bin/bash | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 4015 - ((27 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
4015
normal! 0
tabedit _posts/2018-09-02-generating-pythagoras-trees-using-SFML.md
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
set nosplitbelow
set nosplitright
wincmd t
set winminheight=1 winminwidth=1 winheight=1 winwidth=1
exe 'vert 1resize ' . ((&columns * 106 + 54) / 108)
exe 'vert 2resize ' . ((&columns * 1 + 54) / 108)
argglobal
if bufexists('_posts/2018-09-02-generating-pythagoras-trees-using-SFML.md') | buffer _posts/2018-09-02-generating-pythagoras-trees-using-SFML.md | else | edit _posts/2018-09-02-generating-pythagoras-trees-using-SFML.md | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 213 - ((5 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
213
normal! 034|
wincmd w
argglobal
if bufexists('_includes/image') | buffer _includes/image | else | edit _includes/image | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 3 - ((2 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
3
normal! 015|
wincmd w
exe 'vert 1resize ' . ((&columns * 106 + 54) / 108)
exe 'vert 2resize ' . ((&columns * 1 + 54) / 108)
tabnew
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=1 winminwidth=1 winheight=1 winwidth=1
argglobal
if bufexists('term://.//6719:/bin/bash') | buffer term://.//6719:/bin/bash | else | edit term://.//6719:/bin/bash | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 218 - ((24 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
218
normal! 027|
tabedit assets/posts/2018-09-02-generating-pythagoras-trees-using-sfml
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=1 winminwidth=1 winheight=1 winwidth=1
argglobal
if bufexists('assets/posts/2018-09-02-generating-pythagoras-trees-using-sfml') | buffer assets/posts/2018-09-02-generating-pythagoras-trees-using-sfml | else | edit assets/posts/2018-09-02-generating-pythagoras-trees-using-sfml | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 4 - ((3 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
4
normal! 0
lcd ~/code/5mincode
tabnext 3
set stal=1
if exists('s:wipebuf') && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 winminheight=1 winminwidth=1 shortmess=filnxtToOc
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
