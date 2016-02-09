# ShowMeDB

Easy rails schema (or structure.sql) table finder for neovim / vim

Warning: This project is currently incomplete and unstable.

### Instalation

Use your favorite plugin manager or copy this repo and put files in corensponding folders.

###### Example for vim-plug
```vim
call plug#begin('~/.vim/plugged')

Plug 'rafcamlet/show-me-db'

call plug#end()
```

### Usage

ShowMeDB prefers schema.rb over structure.sql. All commands has bang version, which force using structure.sql. Respectively for mappings is `force` sufix.

```
:ShowMeDB
```
Moves you to table in your schema.rb / structure.sql file, based on your model's name or `self.table_name` if specified.

```
:ShowMeDB table_name
```
Moves you to table, based on typed table's name. Press `<tab>` to autocomplete.

```
:ShowMeDBList
```
Open buffer with tables names listed. Press `<enter>` to jump to table.

```
<plug>show_me_db_fzf
<plug>show_me_db_fzf_force
```
If junegunn/fzf is instaled, open fuzzy seraching with tables. You can map these to custom keys. Don't forget use recursing allow mapping. Example `nmap <leader>db <plug>show_me_db_fzf_force`.

```
<plug>show_me_db_word_under_cursor
<plug>show_me_db_word_under_cursor_force
```
Lookup for table name under currsor

### Configure


Default mappings:

```
  nmap <leader>db <plug>show_me_db_fzf
  nmap <leader>gdb <plug>show_me_db_word_under_cursor
```

Set `let g:ShowMeDB_default_mapping = 0` to disable default mappings.

### FZF integration

![fzf integration gif ](https://raw.githubusercontent.com/rafcamlet/show-me-db/master/gifs/fzf-integration.gif)
