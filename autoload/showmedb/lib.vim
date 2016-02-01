scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" Find expression in current buffer and return result.
" If second attr is set, return submatch num x insted.
" Warning: search starts at the cursor position
function! showmedb#lib#get_match(expression, ...)
  let submatch = a:0 > 0 && a:1 != '' ? a:1 : 0
  let pos = search(a:expression, 'n')
  if pos ==  0
    return 0
  endif

  return substitute(getline(pos), a:expression , '\' . submatch, 'g')
endfunction

" Echo error message
function! showmedb#lib#error(str)
  echohl ErrorMsg
  echomsg a:str
  echohl None
  let v:errmsg = a:str
endfunction

" Return rails_root path or 0 if no rails app detected
" Strongly based on RailsDetect function from tpope/vim-rails
function! showmedb#lib#rails_root(...) abort
  let fn = fnamemodify(a:0 ? a:1 : expand('%'), ':p')
  if fn =~# ':[\/]\{2\}'
    return 0
  endif
  if !isdirectory(fn)
    let fn = fnamemodify(fn, ':h')
  endif
  let file = findfile('config/environment.rb', escape(fn, ', ').';')
  if !empty(file) && isdirectory(fnamemodify(file, ':p:h:h') . '/app')
    return fnamemodify(file, ':p:h:h')
  endif
endfunction

" This is for script writers who wish to save and restore the position of the normal cursor and its screen.
" To save cursor and screen positions: call showmedb#lib#cur_pos("save")
" To restore positions: call showmedb#lib#cur_pos("restore")
" source: http://vim.wikia.com/wiki/Maintain_cursor_and_screen_position

function showmedb#lib#cur_pos(action)
  if a:action == "save"
    let b:saveve = &virtualedit
    let b:savesiso = &sidescrolloff
    set virtualedit=all
    set sidescrolloff=0
    let b:curline = line(".")
    let b:curvcol = virtcol(".")
    let b:curwcol = wincol()
    normal! g0
    let b:algvcol = virtcol(".")
    normal! M
    let b:midline = line(".")
    execute "normal! ".b:curline."G".b:curvcol."|"
    let &virtualedit = b:saveve
    let &sidescrolloff = b:savesiso
  elseif a:action == "restore"
    let b:saveve = &virtualedit
    let b:savesiso = &sidescrolloff
    set virtualedit=all
    set sidescrolloff=0
    execute "normal! ".b:midline."Gzz".b:curline."G0"
    let nw = wincol() - 1
    if b:curvcol != b:curwcol - nw
      execute "normal! ".b:algvcol."|zs"
      let s = wincol() - nw - 1
      if s != 0
        execute "normal! ".s."zl"
      endif
    endif
    execute "normal! ".b:curvcol."|"
    let &virtualedit = b:saveve
    let &sidescrolloff = b:savesiso
    unlet b:saveve b:savesiso b:curline b:curvcol b:curwcol b:algvcol b:midline
  endif
  return ""
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
