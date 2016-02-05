" Easy rails schema (or structure.sql) tabel finder for neovim / vim
" Author: Rafał Camlet <raf.camlet@gmail.com>
" License: MIT
" Version: 0.0.5
" Last Change: 05.02.2016

scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let g:loaded_show_me_db = '0.0.4' " version number

command! -nargs=? -bang ShowMeDBList call showmedb#open_list('!' == '<bang>')
command! -nargs=? -bang -complete=customlist,showmedb#table_list ShowMeDB
 \ call showmedb#main_find('!' == '<bang>', <q-args>)

nnoremap <silent> <plug>show_me_db_fzf :call showmedb#fzf#show_me_db_fzf()<cr>
nnoremap <silent> <plug>show_me_db_fzf_force :call showmedb#fzf#show_me_db_fzf_force()<cr>

nmap <space>db <plug>show_me_db_fzf_force

let &cpo = s:save_cpo
unlet s:save_cpo
