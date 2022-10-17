
" Compiling/sourcing
augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end

" Filetypes
augroup FileTypes
    autocmd!
    autocmd BufNewFile,BufRead *.deckspec set ft=yaml
    autocmd BufNewFile,BufRead *.har set ft=json
    " autocmd BufNewFile,BufRead *.template set ft=yaml
augroup END

" Only show the cursor line in the active buffer.
augroup CursorLine
	autocmd!
	autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
	autocmd WinLeave * setlocal nocursorline
augroup END

" Make nvim stop auto commenting when pasting
autocmd BufNewFile,BufRead * setlocal formatoptions-=cro
augroup custom_tabs
    " Call the function after opening a buffer
    autocmd!
    autocmd BufReadPost * call TabsOrSpaces()
augroup end

" Automatically open help in new tab, instead of default horizontal
augroup vimrc_help
  autocmd!
  autocmd BufEnter *.txt if &buftype == 'help' | wincmd T | endif
augroup END

" Restore last cursor position and marks on open
autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

function TabsOrSpaces()
    " Determines whether to use spaces or tabs on the current buffer.
    if getfsize(bufname("%")) > 256000
        " File is very large, just use the default.
        return
    endif
    let numTabs=len(filter(getbufline(bufname("%"), 1, 250), 'v:val =~ "^\\t"'))
    let numSpaces=len(filter(getbufline(bufname("%"), 1, 250), 'v:val =~ "^ "'))
    if numTabs > numSpaces
        setlocal noexpandtab
    endif
endfunction
