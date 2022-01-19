" -----------------------------------------------------------------------------
" Skeleton Files
" -----------------------------------------------------------------------------
augroup SpookyScarySkeletons
    autocmd!
    autocmd BufNewFile *.c 0r ~/.config/nvim/templates/skeleton.c
    autocmd BufNewFile *.cpp 0r ~/.config/nvim/templates/skeleton.cpp
    autocmd BufNewFile *.java 0r ~/.config/nvim/templates/skeleton.java
    autocmd BufNewFile *.sh 0r ~/.config/nvim/templates/skeleton.sh
    autocmd BufNewFile main.rs 0r ~/.config/nvim/templates/skeleton.rs
augroup END
" -----------------------------------------------------------------------------
" QuickFix and Location (Local) lists
" -----------------------------------------------------------------------------
let g:config_local_list = 0
let g:config_global_list = 0

fun! ToggleQFList(global)
    if a:global
        if g:config_global_list == 1
            let g:config_global_list = 0
            cclose
        else
            let g:config_global_list = 1
            copen
        end
    else
        if g:config_local_list == 1
            let g:config_local_list = 0
            lclose
        else
            let g:config_local_list = 1
            lopen
        end
    endif
endfun

fun! LspLocationList()
    lua vim.lsp.diagnostic.set_loclist({open_loclist = false})
endfun
" -----------------------------------------------------------------------------

" Update the vimwiki diary links
augroup vimwikigroup
    autocmd!
    autocmd BufEnter diary.md VimwikiDiaryGenerateLinks
augroup end

" Compiling/sourcing
augroup install_snippets
    autocmd!
    autocmd BufWritePost *.snip COQsnips compile
augroup end

" Compiling/sourcing
augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end

" Filetypes
augroup FileTypes
    autocmd!
    autocmd BufNewFile,BufRead *.deckspec set syntax=yaml
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

" Automatically open help in VERTICAL split, instead of default horizontal
augroup vimrc_help
  autocmd!
  autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif
augroup END

" Removes whitespace every time the file is saved
augroup FixDisgustingWhitespace
    autocmd!
    autocmd BufWritePre * %s/\s\+$//e
augroup END


" Restore last cursor position and marks on open
autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

" Switch between line number styles when switching modes
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * :lua vim.opt.relativenumber, vim.opt.number = true, false
  autocmd BufLeave,FocusLost,InsertEnter   * :lua vim.opt.relativenumber, vim.opt.number = false, true
augroup END
" Commenting out this because I don't want this to be on when I'm in my vimwiki
" autocmd FileType markdown setlocal spell
autocmd Filetype gitcommit setlocal spell textwidth=72

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 200})
augroup END

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
