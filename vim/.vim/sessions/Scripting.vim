" ~/.vim/sessions/Scripting.vim:
" Vim session script.
" Created by session.vim 2.13.1 on 29 June 2017 at 12:56:20.
" Open this file in Vim and run :source % to restore your session.

if exists('g:syntax_on') != 1 | syntax on | endif
if exists('g:did_load_filetypes') != 1 | filetype on | endif
if exists('g:did_load_ftplugin') != 1 | filetype plugin on | endif
if exists('g:did_indent_on') != 1 | filetype indent on | endif
if &background != 'dark'
	set background=dark
endif
if !exists('g:colors_name') || g:colors_name != 'smyck' | colorscheme smyck | endif
call setqflist([])
let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/Documents/shellScripts
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +12 test.sh
badd +26 gitgo.sh
badd +6 uploadWebDS.sh
badd +23 duplicateLineDeleter.sh
badd +19 shebangChanger.sh
badd +14 createScriptButDontOpenSublime.sh
badd +10 batchRename.sh
badd +16 backupBashConfig.sh
badd +4 backupBashConfig.shtest.shbackupBashConfig.sh
badd +26 animation
argglobal
silent! argdel *
$argadd test.sh
edit undotree_2
set splitbelow splitright
wincmd _ | wincmd |
split
1wincmd k
wincmd _ | wincmd |
vsplit
wincmd _ | wincmd |
vsplit
wincmd _ | wincmd |
vsplit
wincmd _ | wincmd |
vsplit
4wincmd h
wincmd w
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd w
wincmd w
wincmd w
wincmd w
set nosplitbelow
set nosplitright
wincmd t
set winminheight=1 winheight=1 winminwidth=1 winwidth=1
exe '1resize ' . ((&lines * 60 + 35) / 70)
exe 'vert 1resize ' . ((&columns * 40 + 94) / 189)
exe '2resize ' . ((&lines * 31 + 35) / 70)
exe 'vert 2resize ' . ((&columns * 35 + 94) / 189)
exe '3resize ' . ((&lines * 28 + 35) / 70)
exe 'vert 3resize ' . ((&columns * 35 + 94) / 189)
exe '4resize ' . ((&lines * 60 + 35) / 70)
exe 'vert 4resize ' . ((&columns * 25 + 94) / 189)
exe '5resize ' . ((&lines * 60 + 35) / 70)
exe 'vert 5resize ' . ((&columns * 65 + 94) / 189)
exe '6resize ' . ((&lines * 60 + 35) / 70)
exe 'vert 6resize ' . ((&columns * 20 + 94) / 189)
exe '7resize ' . ((&lines * 7 + 35) / 70)
argglobal
enew
" file __Tag_List__
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=9999
setlocal fml=0
setlocal fdn=20
setlocal fen
lcd ~/Documents/shellScripts
wincmd w
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 3 - ((1 * winheight(0) + 15) / 31)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
3
normal! 02|
lcd ~/Documents/shellScripts
wincmd w
argglobal
edit ~/Documents/shellScripts/diffpanel_3
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal nofen
let s:l = 1 - ((0 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/Documents/shellScripts
wincmd w
argglobal
edit ~/Documents/shellScripts/NetrwTreeListing\ 15
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 20 - ((17 * winheight(0) + 30) / 60)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
20
normal! 022|
lcd ~/Documents/shellScripts
wincmd w
argglobal
edit ~/Documents/shellScripts/test.sh
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 17 - ((16 * winheight(0) + 30) / 60)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
17
normal! 0
lcd ~/Documents/shellScripts
wincmd w
argglobal
enew
file ~/Documents/shellScripts/vim-minimap
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
wincmd w
argglobal
enew
file ~/Documents/shellScripts/__tags__
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
lcd ~/Documents/shellScripts
wincmd w
5wincmd w
exe '1resize ' . ((&lines * 60 + 35) / 70)
exe 'vert 1resize ' . ((&columns * 40 + 94) / 189)
exe '2resize ' . ((&lines * 31 + 35) / 70)
exe 'vert 2resize ' . ((&columns * 35 + 94) / 189)
exe '3resize ' . ((&lines * 28 + 35) / 70)
exe 'vert 3resize ' . ((&columns * 35 + 94) / 189)
exe '4resize ' . ((&lines * 60 + 35) / 70)
exe 'vert 4resize ' . ((&columns * 25 + 94) / 189)
exe '5resize ' . ((&lines * 60 + 35) / 70)
exe 'vert 5resize ' . ((&columns * 65 + 94) / 189)
exe '6resize ' . ((&lines * 60 + 35) / 70)
exe 'vert 6resize ' . ((&columns * 20 + 94) / 189)
exe '7resize ' . ((&lines * 7 + 35) / 70)
tabnext 1
if exists('s:wipebuf')
"   silent exe 'bwipe ' . s:wipebuf
endif
" unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToOIc
set winminheight=1 winminwidth=1
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save

" Support for special windows like quick-fix and plug-in windows.
" Everything down here is generated by vim-session (not supported
" by :mksession out of the box).

1wincmd w
tabnext 1
let s:bufnr_save = bufnr("%")
let s:cwd_save = getcwd()
Tlist
if !getbufvar(s:bufnr_save, '&modified')
  let s:wipebuflines = getbufline(s:bufnr_save, 1, '$')
  if len(s:wipebuflines) <= 1 && empty(get(s:wipebuflines, 0, ''))
    silent execute 'bwipeout' s:bufnr_save
  endif
endif
execute "cd" fnameescape(s:cwd_save)
4wincmd w
tabnext 1
let s:bufnr_save = bufnr("%")
let s:cwd_save = getcwd()
edit ~/Documents/shellScripts/NetrwTreeListing\ 15
if !getbufvar(s:bufnr_save, '&modified')
  let s:wipebuflines = getbufline(s:bufnr_save, 1, '$')
  if len(s:wipebuflines) <= 1 && empty(get(s:wipebuflines, 0, ''))
    silent execute 'bwipeout' s:bufnr_save
  endif
endif
execute "cd" fnameescape(s:cwd_save)
1resize 60|vert 1resize 40|2resize 31|vert 2resize 35|3resize 28|vert 3resize 35|4resize 60|vert 4resize 25|5resize 60|vert 5resize 65|6resize 60|vert 6resize 20|7resize 7|vert 7resize 189|
5wincmd w
tabnext 1
if exists('s:wipebuf')
  if empty(bufname(s:wipebuf))
if !getbufvar(s:wipebuf, '&modified')
  let s:wipebuflines = getbufline(s:wipebuf, 1, '$')
  if len(s:wipebuflines) <= 1 && empty(get(s:wipebuflines, 0, ''))
    silent execute 'bwipeout' s:wipebuf
  endif
endif
  endif
endif
doautoall SessionLoadPost
unlet SessionLoad
" vim: ft=vim ro nowrap smc=128
