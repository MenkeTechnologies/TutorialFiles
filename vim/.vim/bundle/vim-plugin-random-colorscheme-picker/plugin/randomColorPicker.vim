" This program is free software. It comes without any warranty, to
" the extent permitted by applicable law. You can redistribute it
" and/or modify it under the terms of the Do What The Fuck You Want
" To Public License, Version 2, as published by Sam Hocevar. See
" http://www.wtfpl.net/txt/copying/ for more details. */
"
" ==ABOUT==
" Power VIM Users like us have already wasted tons of time to choose
" our favorite colorschemes, and may still not be satisfied with the
" current colorschemes. So I wrote this plugin to help us out, to
" meet the perfect colorsheme that we are `DESTINED` to be with.
" just like your lovely girlfriends/wifves:)
" Written by sunus Lee
" sunus.the.dev@gmail.com

function! GetOS()
    if has('unix')
        return 'linux'
    elseif has('win16') || has('win32') || has('win64')
        return 'win'
    endif
endfunction

function! GetRAND()
    if g:os == 'linux'
        return system("echo $RANDOM")
    elseif g:os == 'win'
        return system("echo %RANDOM%")
    endif
endfunction

let g:os=GetOS()

if g:os == 'linux'
    let g:plugin_path=fnamemodify(resolve(expand('<sfile>:p')), ':h')
    let g:slash='/'
    let g:love_path=g:plugin_path.'/.love'
    let g:hate_path=g:plugin_path.'/.hate'
elseif g:os == 'win'
    let g:plugin_path=$HOME.'/vimfiles/plugin'
    let g:slash='\'
    let g:love_path=g:plugin_path.'\love.txt'
    let g:hate_path=g:plugin_path.'\hate.txt'
endif


if !exists('g:colorscheme_user_path')
  let g:colorscheme_user_path = ''
end
let g:colorscheme_file_path=''
let g:colorscheme_file=''
let g:total_colorschemes = 0

function! Picker()
    " Fetch the runtime path and search for 
    " all the color files
    let colorscheme_dirs = []
    for i in split(&runtimepath, ',')
        if !empty(glob(i.'/colors'))
            call add(colorscheme_dirs, i.'/colors')
        endif
    endfor

    let g:all_colorschemes=[]
    for colorsheme_dir in colorscheme_dirs
        let colorschemes=glob(colorsheme_dir.'/*.vim')
        let g:all_colorschemes+=split(colorschemes, '\n')
    endfor

    let arr=[]
    for colorscheme_dir in colorscheme_dirs
        let colorschemes=glob(colorscheme_dir.'/*.vim')
        let arr+=split(colorschemes, '\n')
    endfor
    let g:total_colorschemes = len(arr)
    let hates=[]
    let r=findfile(g:hate_path)
    if r != ''
        let hates=readfile(g:hate_path)
    endif
    let r=findfile(g:love_path)
    if r != ''
        let loves=readfile(g:love_path)
        if len(loves) > 0
            let g:colorscheme_file=loves[0]
            call ApplyCS()
            return
        endif
    endif
    while 1
        let rand=GetRAND()
        let rand=rand%len(arr)
        let g:colorscheme_file_path=arr[rand]
        if index(hates, g:colorscheme_file_path) == -1
            break
        endif
    endwhile
    " colorscheme is /path/to/colorscheme_file.vim
    " convert to colorscheme_file
    let g:colorscheme_file=split(g:colorscheme_file_path, g:slash)[-1][:-5]
    call ApplyCS()
endfunction

function! ApplyCS()
    let cmd='colorscheme '.g:colorscheme_file
   execute cmd
endfunction

function! LoveCS()
    execute writefile([g:colorscheme_file], g:love_path)
endfunction

function! HateCS()
    call delete(g:love_path)
    let r=findfile(g:hate_path)
    if r != ''
        let hates=readfile(g:hate_path)
    else
        let hates=[]
    endif
    if len(hates) + 1 == g:total_colorschemes
        redrawstatus
  echo "She is the last one you got, Can't hate it anymore, or :Back first."
    else
        call add(hates, g:colorscheme_file_path)
        call writefile(hates, g:hate_path)
        call PickAndShow()
    endif
endfunction

function! BackCS()
    execute writefile([], g:hate_path)
    redrawstatus
    echo "you've got all the previously hated colorschemes back"
endfunction

function! ShowCS()
    redrawstatus
    echo 'using colorscheme: '.g:colorscheme_file
endfunction

function! PickAndShow()
  call Picker()
  call ShowCS()
endfunction

call Picker()
autocmd VimEnter * echo 'using colorscheme: '.g:colorscheme_file
command! Love call LoveCS()
command! Hate call HateCS()
command! CS call ShowCS()
command! Back call BackCS()
command! CSnext call PickAndShow()
