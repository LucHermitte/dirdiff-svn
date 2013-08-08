dirdiff-svn
===========

This vim plugin provides a DirDiff-like interface over the VCS Command plugin.


As a long time user of
[DirDiff](http://www.vim.org/scripts/script.php?script_id=102), I was looking
for something similar in order to navigate through the files changed in my
projects managed under SVN. This plugin is a quick answer to that need.

Usage:
--------

Hit `<leader>ds` to start a svn diff session. The current path (see `:echo getcwd()`)
will be used to determine which files are considered. (In other
words, this plugin works on the files returned by `cd getcwd() && svn st`).

Then, you'll be able to navigate through the files that have changed to see the
modifications (hit `<enter>`).  
You can mark the files that you have already checked by hitting `<space>`. Hit
`<space>` again to un-conceal these files.

Eventually, Hit `<leader>de` to end the svn diff session. 

Note: If you've never heard of `<leader>`, check `:h <Leader>`. Anyway, it's likely to be `\` in your vim sessions.


Installation Requirements:
-------------------------
* [Vim 7.3+](http://www.vim.org), compiled with python support
* [lh-vim-lib](http://code.google.com/p/lh-vim/wiki/lhVimLib),
* [VCS command](http://www.vim.org/scripts/script.php?script_id=90).

Options:
--------
* Options to specify under which menu item the plugin command shall be stored
    * `g:dirdiff_svn.menu_priority` (default: `'500.600'`)
    * `g:dirdiff_svn.menu_name`     (default: `'&Plugin.DirDiff SVN'`)
* Options to overide the default keybindings
    * `g:dirdiff_svn.keys.diff` (default: `<leader>ds`), to start a svn diff session.
    * `g:dirdiff_svn.keys.quit` (default: `<leader>dq`), to end a svn diff session.

To do list:
-----------
* Add ways to specify:
    * files to ignore,
    * revision against which the diff shall be done ;
* Write the vim-formatetd documentation ;
* Support other SVN operations (tag to commit, log, blame, info, ...).

Licence:
--------
Copyright 2013 Luc Hermitte

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
