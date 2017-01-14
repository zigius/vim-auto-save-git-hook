# Description

[907th/vim-auto-save](https://github.com/907th/vim-auto-save) pre-save git hook - only save files under git (or any other scm you can think of)
Inspired by [vim-rooter](https://github.com/airblade/vim-rooter)

# Installation

Use your favorite package manger


# Usage

Just install this package and [907th/vim-auto-save](https://github.com/907th/vim-auto-save) and all your git files 
will be automatically saved. All other files will have to be saved manually.


# Options

A lot of the options are taken from vim rooter. for a more detailed explanation view vim-rooter's 
README file

To specify how to identify a project's root directory:

```VimL
" .vimrc
let g:git_patterns = ['.git', '.git/', '_darcs/', '.hg/', '.bzr/', '.svn/'] " default values

```

By default all files and directories trigger git-auto-save.  Configure a comma separated list of file patterns to specify which files trigger git-auto-save.  Include `/` to trigger git-auto-save on directories.

```viml
" directories and all files (default)
let g:git_targets = '/,*'

" ignore directories; all files
let g:git_targets = '*'

" ignore directories; yaml files
let g:git_targets = '*.yml,*.yaml'

" directories and yaml files
let g:git_targets = '/,*.yml,*.yaml'
```

By default git-auto-save doesn't resolve symbolic links.  To resolve links:

```viml
let g:git_resolve_links = 1
```

# Configuration

My preferred settings: 

```VimL
" .vimrc
let g:auto_save = 1
let g:auto_save_silent = 1
let g:auto_save_events = ["CursorHold"]
let updatetime=4000

```

# License

None
