# ShowMeDB

Easy rails schema (or structure.sql) tabel finder for neovim / vim

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

```
:ShowMeDB
```
Move you to tabel in your schema.rb, structure.sql file, based on your model name or `self.table_name` if specific.

```
:ShowMeDB table_name
```
Move you to tabel, based on typed tabel name. Press `<tab>` to autocmplete.

```
:ShowMeDBList
```
Open buffer on right side with tabels names listed. Press `<enter>` to jump to tabel.

```
nnoremap <space>db
```
If junegunn/fzf is instaled, open fuzzy seraching with tabels.


ShowMeDB prefer schema.rb over structure.sql. Tu force using structure.sql add bang to command. Example `:ShowMeDB!`

### FZF integration

![fzf integration gif ](https://raw.githubusercontent.com/rafcamlet/show-me-db/master/gifs/fzf-integration.gif)
