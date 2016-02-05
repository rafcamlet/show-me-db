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
  call fzf#run({
        \ 'source':  showmedb#get_list('', ''),
        \ 'sink': function('s:regular_find_in'),
        \ 'options': '+m',
        \ 'down':    len(showmedb#get_list('', '')) + 2 })
endfunction
"}}}

function! showmedb#fzf#show_me_db_fzf_force() "{{{
  call fzf#run({
        \   'source':  showmedb#get_list('', 'structure'),
        \   'sink':    function('s:force_structure_find_in'),
        \   'options': '+m',
        \   'down':    len(showmedb#get_list('', '')) + 2
        \ })
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
