" Source default config first
if filereadable(expand('~/.config/nvim/init.vim'))
    source ~/.config/nvim/init.vim
endif

" Or if you use init.lua
if filereadable(expand('~/.config/nvim/init.lua'))
    luafile ~/.config/nvim/init.lua
endif

" XS file handling configuration
function! OpenXSFile(filename)
  let ft = fnamemodify(a:filename, ':e')
  
  " Check if file exists in xs store
  let head_check = system('xs head ./store/ ' . shellescape(a:filename))
  let exists = v:shell_error == 0

  if winnr('$') == 1 && expand('%') == '' && line('$') == 1 && getline(1) == ''
    if exists
      execute 'read !xs head ./store/ ' . shellescape(a:filename) . ' | jq -r .hash | xargs -I {} xs cas ./store/ {}'
      normal ggdd
    endif
  else
    enew
    if exists
      execute 'read !xs head ./store/ ' . shellescape(a:filename) . ' | jq -r .hash | xargs -I {} xs cas ./store/ {}'
      normal ggdd
    endif
  endif
  
  execute 'file xs://' . a:filename
  execute 'set filetype=' . ft
  set nomodified
  execute 'map <buffer> :w :w !xs append ./store ' . shellescape(a:filename) . '<CR>:set nomodified<CR>'
  execute 'map <buffer> :wq :w !xs append ./store ' . shellescape(a:filename) . '<CR>:set nomodified<CR>:q<CR>'
endfunction

command! -nargs=1 XS call OpenXSFile(<q-args>)