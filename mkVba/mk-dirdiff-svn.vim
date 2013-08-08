"=============================================================================
" $Id$
" File:         mkVba/mk-dirdiff-svn.vim                          {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
" Version:      001
" Created:      07th Aug 2013
" Last Update:  $Date$
"------------------------------------------------------------------------
" Description:
"       File used to build vimball archives
" }}}1
"=============================================================================

let s:version = '0.0.1'
let s:project = 'dirdiff-svn'
cd <sfile>:p:h
try 
  let save_rtp = &rtp
  let &rtp = expand('<sfile>:p:h:h').','.&rtp
  exe '28,$MkVimball! '.s:project.'-'.s:version
  set modifiable
  set buftype=
finally
  let &rtp = save_rtp
endtry
finish
README.md
dirdiff-svn-addon-info.txt
autoload/lh/svn.vim
plugin/dirdiff-svn.vim
