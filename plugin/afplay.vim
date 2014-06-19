" *********************************************************************
" PluginName: unite_afplay
" Maintener: mittan(E-mail => modsound@gmail.com, Twitter => @modsound)
" License: MIT
" *********************************************************************

" keymap sample
  " autocmd! FileType vimfiler nnoremap <buffer><silent><expr>af vimfiler#do_action('afplay')
  " nnoremap <silent>fa :<C-u>StopAfplay<CR>

" [todo]
  " 連続再生時に都度タイトルを表示
  " afplay以外でも再生できるように

let s:save_cpo = &cpo
set cpo&vim

" for delayed load {{{
function! s:define_unite_actions()

  " set command to play music
  let s:command = exists("g:unite_afplay_command") ? g:unite_afplay_command : 'afplay -q 1'

  " play selected a music {{{
  let s:start_afplay= {
        \'description': 'play selected music by afplay command',
        \'is_selectable': 0,
  \}
  
  " enumerate candidates
  function! s:start_afplay.func(candidate)
    call vimproc#system_bg('killall find')
    call vimproc#system_bg("killall afplay")

    " confirm extension type
    let l:ext = a:candidate.vimfiler__extension
    " [todo]リストで比較する
    if l:ext == 'mp3' || l:ext == 'mp4' || l:ext == 'm4a' || l:ext == 'aiff' || l:ext == 'wav'
      call vimproc#system_bg(s:command." ".shellescape(a:candidate.action__path))

      " notify music title
      if exists("g:loaded_mac_notify") && exists("g:unite_afplay_with_mac_notify")
        MacNotifyExpand a:candidate.vimfiler__filename
      else
        echo "Playing... " . a:candidate.vimfiler__filename
      endif

    else
      echo "Sorry, unsupported file."
    endif
  endfunction
  
  " register a custom action
  call unite#custom_action('file', 'afplay', s:start_afplay)
  unlet s:start_afplay
  " }}}
  
  " play all music in selected directory {{{
  let s:start_afplay_all= {
        \'description': 'play all music in selected directory by afplay command',
        \'is_selectable': 0,
  \}
  
  function! s:start_afplay_all.func(candidate)
    call vimproc#system_bg('killall find')
    call vimproc#system('killall afplay')

    " search & play music in selected directory
    let s:music_dir = shellescape(a:candidate.abbr)
    echo vimproc#system_bg(
          \ 'find '.s:music_dir.
          \ ' \( -name "*.mp3" -or -name "*.m4a" -or -name "*.mp4" -or -name "*.aiff" -or -name "*.wav" \)
          \ -exec '.s:command.' "{}" \;'
    \ )
  endfunction
  
  " register a custom action
  call unite#custom_action('directory', 'afplay', s:start_afplay_all)
  unlet s:start_afplay_all
  " }}}
  
  " unite-afplay_stop {{{
  function! s:stop_afplay()
    "[todo] プロセスを探してkillしたい
    call vimproc#system_bg('killall find')
    call vimproc#system_bg('killall afplay')
  endfunction
  command! StopAfplay call s:stop_afplay()
  " }}}

endfunction
" }}}

" delayed load {{{
augroup UniteCustomActions
  autocmd!
  autocmd FileType unite,vimfiler call <SID>define_unite_actions()
augroup END
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
