scriptencoding utf-8

" you can map IfErr func to any hotkey in your .vimrc like this:
" map <YOUR HOTKEY> <esc>:IfErr<cr>
"
" Example:
" map ff <esc>:IfErr<cr>
"
" After adding the line above typing "ff" in normal mode will add
" the "if err != nil {}" and put the cursor to the appropriate position.

function! s:IfErr()
  let bpos = wordcount()['cursor_bytes']
  let out = systemlist('iferr -pos ' . bpos, bufnr('%'))
  if len(out) == 1
    return
  endif
  let pos = getcurpos()
  call append(pos[1], out)
  silent normal! j=2j
  call setpos('.', pos)
  " move the cursor to the line with "return"
  silent normal! 02j
  if stridx(getline('.'), "fmt.Errorf") > -1
	" move the cursor to the empty space in quotes if the line contains fmt.Errorf
    silent normal! 7w2h
  else
	" it's a simple "return", so move the cursor to the last curly bracket
	silent normal! 1j1w
  endif
endfunction

command! -buffer -nargs=0 IfErr call s:IfErr()
