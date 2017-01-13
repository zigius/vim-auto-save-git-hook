if !exists('g:git_patterns')
  let g:git_patterns = ['.git', '.git/', '_darcs/', '.hg/', '.bzr/', '.svn/']
endif

if !exists('g:git_targets')
  let g:git_targets = '/,*'
endif

if !exists('g:git_resolve_links')
  let g:git_resolve_links = 0
endif

command! SetIsGitDirectory :call SetIsGitDirectory()
command! AbortIfNotGitDirectory :call AbortIfNotGitDirectory()

" just for now. will be moved to vimrc
let  g:auto_save_BufEnter_hook = 'SetIsGitDirectory'
let  g:auto_save_presave_hook = 'AbortIfNotGitDirectory'
let  g:is_git_directory = 0

function! AbortIfNotGitDirectory()
  if g:auto_save >= 1
    if g:is_git_directory = 0
      let g:auto_save = 0
    endif
  endif
endfunction

function! s:FindAncestor(pattern)
  let fd_dir = isdirectory(s:fd) ? s:fd : fnamemodify(s:fd, ':h')

  if s:IsDirectory(a:pattern)
    let match = finddir(a:pattern, fnameescape(fd_dir).';')
  else
    let match = findfile(a:pattern, fnameescape(fd_dir).';')
  endif

  if empty(match)
    return ''
  endif

  if s:IsDirectory(a:pattern)
    return fnamemodify(match, ':p:h:h')
  else
    return fnamemodify(match, ':p:h')
  endif
endfunction

function! s:SearchForRootDirectory()
  for pattern in g:git_patterns
    let result = s:FindAncestor(pattern)
    if !empty(result)
      return result
    endif
  endfor
  return ''
endfunction

function! s:RootDirectory()
  let root_dir = getbufvar('%', 'rootDir')
  if empty(root_dir)
    let root_dir = s:SearchForRootDirectory()
    if !empty(root_dir)
      call setbufvar('%', 'rootDir', root_dir)
    endif
  endif
  return root_dir
endfunction

" Code taken from vim-rooter. thanks!
function! s:FindRootDirectory()
  let s:fd = expand('%:p')

  if g:git_resolve_links
    let s:fd = resolve(s:fd)
  endif

  if !s:ChangeDirectoryForBuffer()
    return ''
  endif

  return s:RootDirectory()
endfunction

function! SetIsGitDirectory()
  let git_directory = s:FindRootDirectory()
  if empty(git_directory)
    let g:is_git_directory = 0
  else
    let g:is_git_directory = 1
  endif
endfunction


