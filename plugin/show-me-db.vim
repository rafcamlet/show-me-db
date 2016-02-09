" Easy rails schema (or structure.sql) table finder for neovim / vim
" Author: Rafał Camlet <raf.camlet@gmail.com>
" License: MIT
" Version: 0.0.6
" Last Change: 09.02.2016

scriptencoding utf-8

if expand("%:p") ==# expand("<sfile>:p") | unlet! g:ShowMeDB_loaded | endif
if exists('g:loaded_show_me_db') | finish | endif

let g:ShowMeDB_loaded = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=? -bang ShowMeDBList call showmedb#open_list('!' == '<bang>')
command! -nargs=? -bang -complete=customlist,showmedb#table_list ShowMeDB
 \ call showmedb#main_find('!' == '<bang>', <q-args>)

nnoremap <silent> <plug>show_me_db_fzf :call showmedb#fzf#show_me_db_fzf()<cr>
nnoremap <silent> <plug>show_me_db_fzf_force :call showmedb#fzf#show_me_db_fzf_force()<cr>

nnoremap <silent> <plug>show_me_db_word_under_cursor :call showmedb#main_find(0, expand('<cword>'))<cr>
nnoremap <silent> <plug>show_me_db_word_under_cursor_force :call showmedb#main_find(1, expand('<cword>'))<cr>

let g:ShowMeDB_default_mapping = get(g:, 'ShowMeDB_default_mapping', 1)

if g:ShowMeDB_default_mapping
  nmap <leader>db <plug>show_me_db_fzf
  nmap <leader>gdb <plug>show_me_db_word_under_cursor
endif

let &cpo = s:save_cpo
unlet s:save_cpo
