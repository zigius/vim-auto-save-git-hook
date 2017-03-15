if !exists('g:git_patterns')
  let g:git_patterns = ['.git', '.git/', '_darcs/', '.hg/', '.bzr/', '.svn/']
endif

if !exists('g:git_targets')
  let g:git_targets = '/,*'
endif

if !exists('g:git_resolve_links')
  let g:git_resolve_links = 0
endif

if !exists('g:is_git_directory')
  let g:is_git_directory = 0
endif
if !exists('g:auto_save_presave_hook')
  let g:auto_save_presave_hook =  'AbortIfNotGitDirectory'
endif

augroup git_auto_save
  autocmd!
  execute "au BufEnter * nested call SetIsAutoSaveEnabled()" 
augroup END

command! AbortIfNotGitDirectory :call AbortIfNotGitDirectory()

function! AbortIfNotGitDirectory()
  if g:auto_save >= 1
    if g:is_git_directory == 0
      let g:auto_save_abort = 1
    else
      let g:auto_save_abort = 0
    endif
  endif
endfunction

function! s:IsDirectory(pattern)
  return stridx(a:pattern, '/') != -1
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

function! SetIsAutoSaveEnabled()
  let git_directory = s:FindRootDirectory()
  if empty(git_directory)
    let g:is_git_directory = 0
  else
    let g:is_git_directory = 1
  endif
endfunction

function! s:ChangeDirectoryForBuffer()
  let patterns = split(g:git_targets, ',')

  if isdirectory(s:fd)
    return index(patterns, '/') != -1
  endif

  if filereadable(s:fd) && empty(&buftype)
    if exists('*glob2regpat')
      for p in patterns
        if p !=# '/' && s:fd =~# glob2regpat(p)
          return 1
        endif
      endfor
    else
      return 1
    endif
  endif

  return 0
endfunction
