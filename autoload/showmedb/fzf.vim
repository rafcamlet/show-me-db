scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

function! s:regular_find_in(word) " {{{
  call showmedb#find_in(a:word)
endfunction
"}}}

function! s:force_structure_find_in(word) " {{{
  call showmedb#find_in(a:word, 'structure')
endfunction
"}}}

function! showmedb#fzf#show_me_db_fzf() "{{{
  let source_list = showmedb#get_list('', '')
  if empty(source_list)
    call showmedb#lib#error('No tables found!')
    return 0
  endif

  call fzf#run({
        \ 'source': source_list,
        \ 'sink': function('s:regular_find_in'),
        \ 'options': '+m',
        \ 'down':    len(showmedb#get_list('', '')) + 2 })
endfunction
"}}}

function! showmedb#fzf#show_me_db_fzf_force() "{{{
  let source_list = showmedb#get_list('', 'structure')
  if empty(source_list)
    call showmedb#lib#error('No tables found!')
    return 0
  endif

  call fzf#run({
        \   'source':  source_list,
        \   'sink':    function('s:force_structure_find_in'),
        \   'options': '+m',
        \   'down':    len(showmedb#get_list('', '')) + 2
        \ })
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
