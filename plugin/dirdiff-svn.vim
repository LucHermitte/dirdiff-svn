"=============================================================================
" $Id$
" File:         plugin/dirdiff-svn.vim         {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://code.google.com/p/lh-vim/>
" Version:      001
" Created:      07th Aug 2013
" Last Update:  $Date$
"------------------------------------------------------------------------
" Description:
"       DirDiff like plugin for svn
" 
"------------------------------------------------------------------------
" Installation:
"       Requires Vim7+, lh-vim-lib, VCS command
" }}}1
"=============================================================================

" Avoid global reinclusion {{{1
let s:k_version = '001'
if &cp || (exists("g:loaded_dirdiff_svn")
      \ && (g:loaded_dirdiff_svn >= s:k_version)
      \ && !exists('g:force_reload_dirdiff_svn'))
  finish
endif
let g:loaded_dirdiff_svn = s:k_version
let s:cpo_save=&cpo
set cpo&vim
" Avoid global reinclusion }}}1
"------------------------------------------------------------------------
" Options {{{1
LetIfUndef g:dirdiff_svn.menu_priority '500.600'
LetIfUndef g:dirdiff_svn.menu_name     '&Plugin.DirDiff\ SVN'
LetIfUndef g:dirdiff_svn.keys.diff     '<leader>ds'
LetIfUndef g:dirdiff_svn.keys.quit     '<leader>dq'

" Commands and Mappings {{{1
call lh#menu#make('nic',
    \ g:dirdiff_svn.menu_priority.'.10', g:dirdiff_svn.menu_name.'.&Diff',
    \ g:dirdiff_svn.keys.diff, '', ':call lh#svn#diff()<cr>' )
call lh#menu#make('nic',
    \ g:dirdiff_svn.menu_priority.'.20', g:dirdiff_svn.menu_name.'.&Quit',
    \ g:dirdiff_svn.keys.quit, '', ':call lh#svn#quit()<cr>' )
" }}}1
"------------------------------------------------------------------------
" Functions {{{1
" Note: most functions are best placed into
" autoload/«your-initials»/«dirdiff_svn».vim
" Keep here only the functions are are required when the plugin is loaded,
" like functions that help building a vim-menu for this plugin.
" Functions }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
