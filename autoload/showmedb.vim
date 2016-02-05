scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:current_serach = ''

function! showmedb#boot_for_buff() " {{{
  if exists('b:show_me_db_init') | return 0 | endif

  let b:show_me_db_init = 1
  let b:rails_root = showmedb#lib#rails_root()
  if empty(b:rails_root) | return 0 | endif

  let b:use_schema = filereadable(b:rails_root . "/db/schema.rb")
  let b:use_structure = filereadable(b:rails_root . "/db/structure.sql")
endfunction
" }}}

function! showmedb#open_list(bang) " {{{
  if exists('s:view') && bufloaded(s:view) | exec s:view.'bd!' | endif

  exec 'silent pedit ShowMeDBList'

  wincmd P | wincmd L

  let s:view = bufnr('%')
  set modifiable

  call append(0, 'List of tables names in structure.sql:')
  call append(2, showmedb#get_list('', a:bang ? 'structure' : '' ))

  setl buftype=nofile
  setl noswapfile
  set  bufhidden=wipe

  setl cursorline
  setl nonu ro noma
  if (exists('&relativenumber')) | setl norelativenumber | endif

  command! -nargs=1 -buffer OpenThis call showmedb#find_in(<q-args>)
  nnoremap <silent> <buffer> <cr> :exec "OpenThis " .  getline('.')<cr>

  exec ':3'
endfunction
" }}}

function! showmedb#find_in(word, ...) " {{{
  let use = a:0 > 0 ? a:1 : ''

  if (b:use_schema && use != 'structure')
    exec 'silent pedit ' . b:rails_root . "/db/schema.rb"
    wincmd P | wincmd L
    call search('\v\ccreate_table "' . a:word . '(s|es)?"')
  elseif (b:use_structure || use == 'structure')
    exec 'silent pedit ' . b:rails_root . "/db/structure.sql"
    wincmd P | wincmd L
    call search('\v\cCREATE.TABLE ' . a:word . '(s|es)?\s')
  endif

  normal! zt
endfunction
"}}}

function! showmedb#find_name_in_model() " {{{
  normal! gg
  let str = showmedb#lib#get_match('\vself\.table_name.*''([a-z_]*)''', 1)

  if empty(str)
    let str = showmedb#lib#get_match('\vclass\s+([a-zA-Z:]*).*ActiveRecord::Base', 1)
    if empty(str) | return 0 | endif

    let str = substitute(str, '::', '_', 'g')
    let str = substitute(str, '\v\C([a-zA-Z])@<=([A-Z])', '_\L\2', 'g')
    let str = substitute(str, '\v.*', '\L\0', '')
  endif

  let str = substitute(str, ' ', '', 'g')
  return str
endfunction
"}}}

function! showmedb#main_find(bang, ...) " {{{
  call showmedb#boot_for_buff()

  if empty(b:rails_root) || (empty(b:use_schema) && empty(b:use_structure))
    return 0
  endif

  if (b:use_schema && !a:bang && a:0 > 0 && a:1 != '')
    return showmedb#find_in(a:1, 'schema')
  endif

  if (b:use_structure && a:0 > 0 && a:1 != '')
    return showmedb#find_in(a:1, 'structure')
  endif

  call showmedb#lib#cur_pos('save')

  let str = showmedb#find_name_in_model()
  if empty(str) | return showmedb#lib#cur_pos('restore') | endif

  if (b:use_schema && !a:bang ) | return showmedb#find_in(str, 'schema') | endif
  if (b:use_structure) | return showmedb#find_in(str, 'structure') | endif
endfunction
"}}}

function! showmedb#get_list(exp, use) "{{{
  call showmedb#boot_for_buff()

  if empty(b:rails_root) || (empty(b:use_schema) && empty(b:use_structure))
    return 0
  endif

  if (b:use_schema && a:use != 'structure')
    let tables = readfile(b:rails_root . "/db/schema.rb")
    let regexp = '\v\Ccreate_table "([a-z_]{-}' . a:exp .  '[a-z_]*)"'
    let sub = '\1'

    call map(tables, 'matchstr(v:val, regexp)')
    call filter(tables, 'strlen(v:val)')
    return map(tables, 'substitute(v:val, regexp, sub, "g")')
  endif

  if (b:use_structure)
    let tables = readfile(b:rails_root . "/db/structure.sql")
    let regexp = '\v\CCREATE TABLE ([a-z_]{-}' . a:exp .  '[a-z_]*)\s'
    let sub = '\1'

    call map(tables, 'matchstr(v:val, regexp)')
    call filter(tables, 'strlen(v:val)')
    return map(tables, 'substitute(v:val, regexp, sub, "g")')
  endif
endfunction
"}}}

function! showmedb#custom_sort(f, s) "{{{
  let f_points = match(a:f, s:current_serach) + (len(a:f) - len(s:current_serach))
  let s_points = match(a:s, s:current_serach) + (len(a:s) - len(s:current_serach))

  if f_points < s_points
    return -1
  elseif f_points > s_points
    return 1
  else
    return 0
  endif
endfunction
"}}}

function! showmedb#table_list(A,L,P) "{{{
  let showmedb#current_serach = a:A
  let bang = (a:L =~ 'ShowMeDB!') ? 1 : 0
  return sort(showmedb#get_list(a:A, bang ? 'structure' : ''), 'showmedb#custom_sort' )
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
