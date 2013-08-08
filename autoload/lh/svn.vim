"=============================================================================
" $Id$
" File:         autoload/lh/svn.vim            {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
" Version:      001
" Created:      07th Aug 2013
" Last Update:  $Date$
"------------------------------------------------------------------------
" Description:
"       «description»
" 
"------------------------------------------------------------------------
" Installation:
"       Requires Vim7+, lh-vim-lib
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
" ## Misc Functions     {{{1
" # Version {{{2
let s:k_version = '001'
function! lh#svn#version()
  return s:k_version
endfunction

" # Debug   {{{2
let s:verbose = 0
function! lh#svn#verbose(...)
  if a:0 > 0 | let s:verbose = a:1 | endif
  return s:verbose
endfunction

function! s:Verbose(expr)
  if s:verbose
    echomsg a:expr
  endif
endfunction

function! lh#svn#debug(expr)
  return eval(a:expr)
endfunction


"------------------------------------------------------------------------
" ## Exported functions {{{1

" Function: lh#svn#quit() {{{3
function! lh#svn#quit()
  if exists('s:dialog')
    silent exe 'bw ' . (s:dialog.id)
  endif
endfunction

" Function: lh#svn#diff() {{{3
function! lh#svn#diff()
  " close this buffer if already open
  silent! bw! svn-dirdiff

  let s:changed_files = split(system('svn st'), '\n')
  let s:dialog = lh#buffer#dialog#new(
        \ 'file-selector',
        \ 'svn dirdiff '.g:loaded_dirdiff_svn.': Select a changed file to explore modifications',
        \ 'bot',
        \ 0,
        \ 'lh#svn#_select', s:changed_files)

  " PostInit() zone
  nnoremap <silent> <buffer> c       :call <sid>Check(line('.'))<cr>
  nnoremap <silent> <buffer> <space> :call <sid>Check(line('.'))<cr><down>
  call lh#buffer#dialog#add_help(s:dialog, '@| c, <space>              : (C)heck: file already analysed', 'long')

  augroup DirDiff_SVN
    au!
    au BufUnload file-selector call s:CloseCurrentDiff()
  augroup END

  if has('syntax')
    syn clear

    syntax region SVNDiff_Conflict start='C' end='$'
    syntax region SVNDiff_Modified start='M' end='$'
    syntax region SVNDiff_New      start='?' end='$'
    syntax region SVNDiff_Checked  start='X' end='$'

    syntax region SVNDiffExplain start='@' end='$' contains=SVNDiffStart
    syntax match SVNDiffStart /@/ contained
    syntax match Statement /--abort--/

    highlight link SVNDiffExplain Comment
    highlight link SVNDiff_New Special
    highlight link SVNDiff_Conflict WarningMsg
    highlight link SVNDiff_Modified Normal
    highlight link SVNDiff_Checked Conceal
    highlight link SVNDiffStart Ignore
  endif
endfunction

"------------------------------------------------------------------------
" ## Internal functions {{{1
" Function: lh#svn#_select(item, ...) {{{3
function! lh#svn#_select(item, ...)
  if len(a:item.selection) > 1
    " this is an assert
    throw "dirdiff-svn: We are not supposed to select several files"
  endif
  let selection = a:item.selection[0]

  let choices = a:item.dialog.choices
  echomsg '-> '.choices[selection]
  " echomsg '-> '.info[selection-1].filename . ": ".info[selection-1].cmd
  if exists('s:quit') | :quit | endif
  " call s:JumpToTag(cmd, info[selection-1])
  call s:DiffToSvn(s:changed_files[selection])
endfunction

" Function: s:DiffToSvn(status_line) {{{3
let s:current_diff = ''
function! s:DiffToSvn(status_line)
  let [status, filename] = split(a:status_line)
  let original_window = lh#buffer#find(filename)
  if original_window > 0 " already there
    call setbufvar(winbufnr(original_window), 'dirdiff_svn_wasthere', 1)
  else
    silent exe 'sp '.filename
  endif

  if s:current_diff == filename
    let buffers = lh#list#copy_if(range(0, bufnr('$')), [], 'getbufvar(v:1_, "VCSCommandCommand") == "vimdiff" && getbufvar(v:1_, VCSCommandOriginalBuffer)=='.original_buffer)
    echomsg "buffers matching:".join(buffers, ' ')
    if !empty(buffers)
      return
    endif
  endif

  call s:CloseCurrentDiff(filename)
  let s:current_diff = filename

  call lh#buffer#find(filename)
  if '?' != status
    VCSVimDiff
  endif
endfunction

" Function: s:CloseCurrentDiff([new_current_file]) {{{3
function! s:CloseCurrentDiff(...)
  if a:0>0 && s:current_diff == a:1
    return 1
  else
    " find buffers with variable VCSCommandCommand == vimdiff
    let buffers = lh#list#copy_if(range(0, bufnr('$')), [], 'getbufvar(v:1_, "VCSCommandCommand") == "vimdiff"')
    if !empty(buffers)
      " assert len(buffers) == 1
      let original = getbufvar(buffers[0], 'VCSCommandOriginalBuffer')
      let should_wipeout_original = ! getbufvar(original, 'dirdiff_svn_wasthere', 0)
      silent exe 'bw '.join(buffers, ' ')
      if should_wipeout_original
        silent exe 'bw ' . original
      endif
    endif
  endif
endfunction

" Function: s:Check(line) {{{3
function! s:Check(line)
  try 
    set noro
    let s = getline(a:line)
    let s = (s[0]=='X' ? ' ' : 'X').s[1:]
    call setline(a:line, s)
  finally
    set ro
  endtry
endfunction
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
