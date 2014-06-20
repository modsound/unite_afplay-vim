unite_afplay-vim
==============

This plugin adds unite action playing music for Vimfiler.

## Requirements

* command: afplay
* plugin: [vimproc](https://github.com/Shougo/vimproc.vim.git), [Vimfiler](https://github.com/Shougo/vimfiler.vim.git)

## Installation

```
NeoBundle 'modsound/unite_afplay-vim.git'
```

## How to use

After adding settings as follows in your vimrc, Please open your music directory by Vimfiler.  
If you select music file or music directory and press key you set("af" as follows), Vim will play music background.

### keymap sample

```
autocmd! FileType vimfiler nnoremap <buffer><silent><expr>af vimfiler#do_action('afplay')
nnoremap <silent>fa :<C-u>StopAfplay<CR>
```

## Configuration

* If you have installed mac_notify-vim, You can receive notice of song title.

```
let g:unite_afplay_with_mac_notify = 1
```

## Todo

* Receiving notice when playing not only a song but songs
* Being able to use command besides afplay
