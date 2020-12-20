" Auto install/update these extensions
let g:coc_global_extensions = [
  \ 'coc-css',
  \ 'coc-eslint',
  \ 'coc-git',
  \ 'coc-highlight',
  \ 'coc-html',
  \ 'coc-java',
  \ 'coc-jedi',
  \ 'coc-json',
  \ 'coc-python',
  \ 'coc-rust-analyzer',
  \ 'coc-snippets',
  \ 'coc-tslint',
  \ 'coc-tsserver',
  \ 'coc-tsserver',
  \ 'coc-yaml',
  \ ]

" -----------------------------------------------------------------------------
" Plugins
" -----------------------------------------------------------------------------

" Specify a directory for plugins.
call plug#begin('~/.vim/plugged')
Plug 'drewtempelmeyer/palenight.vim'           " Palenight theme
Plug 'honza/vim-snippets'                      " Provides actual snippets
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }}
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'                    " In a nutshell...insert } after typing { (same goes for quotes, etc.)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'                       " Distraction free writing
Plug 'junegunn/vim-easy-align'                 " Align into columns with ga<motion><what to align cols around
Plug 'machakann/vim-highlightedyank'           " Briefly highlight which text was yanked
Plug 'mhinz/vim-signify'
Plug 'mhinz/vim-startify'                      " Vim start screen (with session selection)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'                      " Nerdtree
Plug 'rakr/vim-one'                            " Vim-one colorscheme default for atom
Plug 'reedes/vim-colors-pencil'                " Colorscheme for writing prose (for use with goyo)
Plug 'rhysd/clever-f.vim'                      " Better f-movement - repeat w/ f or F
Plug 'scrooloose/nerdcommenter'                " Comment file with <Ctrl-/> (same as VSCode)
Plug 'sheerun/vim-polyglot'                    " Syntax and other support for almost every programming language
Plug 'sirver/ultisnips'                        " Track the engine.
Plug 'tiagofumo/vim-nerdtree-syntax-highlight' " Syntax highlighter for nerdtree
Plug 'tpope/vim-abolish'                       " Coercion between snake_case, camelCase, etc. (crs & crc)
Plug 'tpope/vim-fugitive'                      " Adds Gread, Gwrite, etc. all of which use buffer
Plug 'tpope/vim-markdown'                      " Markdown support
Plug 'tpope/vim-repeat'                        " Repeat plugins with '.'
Plug 'tpope/vim-surround'                      " Surround words
Plug 'wellle/targets.vim'                      " Better text object movement
Plug 'xolox/vim-misc'                          " Dependency for xolox/vim-session
Plug 'AndrewRadev/splitjoin.vim'                   " Convert lines: gS 1-many, and gJ many-1

" Must load this plugin last
Plug 'ryanoasis/vim-devicons'                  " Add filetype icons to nerdtree


call plug#end()

" -----------------------------------------------------------------------------
" Color settings
" -----------------------------------------------------------------------------

" Enable 24-bit true colors
set termguicolors

colorscheme one

" Enable true colors
if (has("nvim"))
	"For Neovim 0.1.3 and 0.1.4 <
	"https://github.com/neovim/neovim/pull/2198 >
	let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

" Highlight matching pairs of brackets. Use the '%' character to jump between them.
set matchpairs+=<:>

" Ctrl-l will clear highlighted search results
nnoremap <C-l> :nohlsearch<CR><C-L>
"set nohlsearch

" Sync and syntax refresh stuff
syntax enable
syntax sync fromstart
set redrawtime=10000

" current cursorline number (make it a pretty orange)
highlight CursorLineNr guifg=#fb801a

" -----------------------------------------------------------------------------
" Status line
" -----------------------------------------------------------------------------

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

function! s:statusline_expr()
    let mod = "%{&modified ? '[+] ' : !&modifiable ? '[x] ' : ''}"
    let ro  = "%{&readonly ? '[RO] ' : ''}"
    let ft  = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
    let fug = "%{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}"
    let sep = ' %= '
    let pos = ' %-12(%l : %c%V%) '
    let pct = ' %P'

    return '[%n] %f %<'.mod.ro.ft.fug.sep.pos.'%*'.pct
endfunction

let &statusline = s:statusline_expr()
" -----------------------------------------------------------------------------
" junegunn/vim-easy-align
" -----------------------------------------------------------------------------

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" -----------------------------------------------------------------------------
" preservim/nerdtree
" -----------------------------------------------------------------------------
nnoremap <silent> <expr> <C-n> g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" : bufexists(expand('%')) ? "\:NERDTreeFind<CR>" : "\:NERDTree<CR>"
let g:NERDTreeShowHidden=1
let g:NERDTreeAutoDeleteBuffer=1
let g:NERDTreeQuitOnOpen=0
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let g:webdevicons_enable = 1
let g:webdevicons_conceal_nerdtree_brackets = 1
" Close tab if nerdtree is last remaining buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Open it automatically
" Augroup nerdtree_open
"         autocmd!
"         autocmd VimEnter * NERDTree | wincmd p
" Augroup END

" -----------------------------------------------------------------------------
" Spell Check
" -----------------------------------------------------------------------------

" Toggle spell check.
noremap <F6> :setlocal spell!<CR>

" Go back to last misspelled word and pick first suggestion.
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" Some abbreviations are set in /nvim/after/plugin/abolish.vim

" -----------------------------------------------------------------------------
" Basic Settings
" -----------------------------------------------------------------------------

" Delete all buffers except for current
command! BufOnly silent! execute "%bd|e#|bd#"

autocmd FileType markdown setlocal spell
autocmd Filetype gitcommit setlocal spell textwidth=72

" Switch between line number styles when swithing modes
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

au TermOpen * if &buftype == 'terminal' | :startinsert | endif " Start terminal in insert mode
command! FixWhitespace :%s/\s\+$//e                            " Remove trailing whitespaces

let mapleader = ","        " Leader key

set autochdir               " Set CWD automatically when changing buffers
set clipboard+=unnamedplus  " Vim clipboard will share system clipboard
set cmdheight=2             " Give more space for displaying messages.
set conceallevel=3          " Removes square brackets from devicons
set encoding=UTF-8          " Encoding
set expandtab               " Turn tabs into spaces
set fileencoding=UTF-8      " Encoding
set fileencodings=UTF-8     " Encoding
set hidden                  " Allow switching between buffers without saving
set ignorecase              " Case insensitive searching
set inccommand=split        " Live substitution with search&replace (:%s)
set lazyredraw              " Speeds up scrolling
set mouse=a                 " Mouse support
set nobackup                " Some servers have issues with backup files, see #649.
set noerrorbells
set nowritebackup           " Some servers have issues with backup files, see #649.
set number relativenumber   " Relative line numbers
set regexpengine=1          " Speeds up scrolling
set scrolloff=2             " Always show at least one line above/below the cursor.
set shiftwidth=4            " The number of spaces in a tab
set shortmess+=c            " Don't pass messages to \|ins-completion-menu\|.
set sidescrolloff=5         " Always show at least one line left/right of the cursor.
set smartcase               " Will automatically switch to case sensitive if you use any capitals
set splitbelow              " Open vertical splits BELOW current buffer
set splitright              " Open horizontal splits RIGHT of current buffer
set tabstop=4 softtabstop=4 " Use 4 spaces for a tab
set updatetime=100          " Having longer updatetime (default is 4000ms) causes delays
set wrap!                   " Disable soft wrapping

" Always show the signcolumn, otherwise it would shift the text each time
" Diagnostics appear/become resolved.
if has("patch-8.1.1564")
	" Recently vim can merge signcolumn and number column into one
	set signcolumn=number
else
	set signcolumn=yes
endif

" autocmd VimResized * wincmd = " Auto-resize splits when Vim gets resized.

" Only show the cursor line in the active buffer.
augroup CursorLine
	au!
	au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
	au WinLeave * setlocal nocursorline
augroup END

" Set font for neovide and other gui editors
set guifont=Iosevka:h12

if exists("g:loaded_webdevicons")
        call webdevicons#refresh()
endif

" Automatically open help in VERTICAL split, instead of default horizontal
augroup vimrc_help
  autocmd!
  autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif
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
augroup custom_tabs
    " Call the function after opening a buffer
    autocmd BufReadPost * call TabsOrSpaces()
augroup end

" -----------------------------------------------------------------------------
" Basic Mappings
" -----------------------------------------------------------------------------

" Dvorak Rebinds | - goes to start of text in line, _ goes to end
no - $
no _ ^

" Prevent x from overriding what's in the clipboard.
noremap x "_x
noremap X "_x

" Don't lose clip on paste
vnoremap p "_dP
" Yank to clipboard
nnoremap y "+y
vnoremap y "+y
" Y will copy to the end of the line, without newline character
nmap Y vg_y


" When changes are made using git pull or git stash, press F5 to reload
nnoremap <F5> :checktime<CR>

" Sort words in selection (works in-line)
vnoremap <F2> d:execute 'normal a' . join(sort(split(getreg('"'))), ' ')<CR>

" Edit init.vim by pressing ', + v'
nnoremap <leader>v :execute "edit " . stdpath("config")<CR>

" Quick exit insert mode with jk
inoremap jk <ESC>
inoremap JK <ESC>

" Exit out of terminal with usual escape keybind
tnoremap jk <C-\><C-n>
tnoremap JK <C-\><C-n>

" Keep cursor at the bottom of the visual selection after you yank it.
vmap y ygv<Esc>

" Preview file in markdown
nnoremap <C-m> :MarkdownPreview<CR>

" To use `ALT+{h,j,k,l}` to navigate windows from any mode:
:tnoremap <A-h> <C-\><C-N><C-w>h
:tnoremap <A-j> <C-\><C-N><C-w>j
:tnoremap <A-k> <C-\><C-N><C-w>k
:tnoremap <A-l> <C-\><C-N><C-w>l
:inoremap <A-h> <C-\><C-N><C-w>h
:inoremap <A-j> <C-\><C-N><C-w>j
:inoremap <A-k> <C-\><C-N><C-w>k
:inoremap <A-l> <C-\><C-N><C-w>l
:nnoremap <A-h> <C-w>h
:nnoremap <A-j> <C-w>j
:nnoremap <A-k> <C-w>k
:nnoremap <A-l> <C-w>l

" Neovim terminal shortcuts: fullscreen, right, and bottom
nnoremap <silent> <leader>tt :terminal<CR>
nnoremap <silent> <leader>tv :vnew<CR>:terminal<CR>
nnoremap <silent> <leader>th :new<CR>:terminal<CR>

" Restore last cursor position and marks on open
au BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

" Make nvim stop auto commenting when pasting
autocmd BufNewFile,BufRead * setlocal formatoptions-=cro

" Replace instances of word under cursor
nnoremap <leader>r :%s/\<<C-r><C-w>\>/
" Replace words with multile forms using abolish.vim
nnoremap <leader>ra :%S//g<Left><Left>
" Replace in visual selection
xnoremap <leader>r :S//g<Left><Left>

" Move by one line
nnoremap j gj
nnoremap k gk

" -----------------------------------------------------------------------------
" scrooloose/nerdcommenter
" -----------------------------------------------------------------------------

filetype plugin on                   " Used for nerdcommenter
let g:NERDSpaceDelims = 1            " Add spaces after comment delimiters by default
let g:NERDCompactSexyComs = 1        " Use compact syntax for prettified multi-line comments
let g:NERDDefaultAlign = 'left'      " Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDTrimTrailingWhitespace = 1 " Enable trimming of trailing whitespace when uncommenting

" Comment line with Ctrl + / (backslash)
nmap <C-/> <plug>NERDCommenterToggle
vmap <C-/> <plug>NERDCommenterToggle

" -----------------------------------------------------------------------------
" sirver/ultisnips
" -----------------------------------------------------------------------------

let g:UltiSnipsExpandTrigger='<c-tab>'
let g:UltiSnipsJumpForwardTrigger='<c-j>'
let g:UltiSnipsJumpBackwardTrigger='<c-k>'

" -----------------------------------------------------------------------------
" neoclide/coc.nvim
" -----------------------------------------------------------------------------

" Gh - get hint on whatever is under the cursor
nnoremap <silent> gh :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gb <Plug>(coc-implementation)

" use <tab> for trigger completion and navigate to the next complete item
" NOTE: Use command ':verbose imap <tab>' to fix if not working
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" Navigate the complete menu items
inoremap <expr> <c-j> pumvisible() ? "\<C-n>" : "\<c-j>"
inoremap <expr> <c-k> pumvisible() ? "\<C-p>" : "\<c-k>"

" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
"nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> <C-e> <Plug>(coc-diagnostic-next)

" Restart when tsserver gets wonky
nnoremap <silent> <leader>cr  :<C-u>CocRestart<CR>

nnoremap <silent> <leader>cl :CocDiagnostics<CR>

" -----------------------------------------------------------------------------
" junegunn/goyo.vim
" -----------------------------------------------------------------------------

nnoremap <leader>gy :Goyo<CR>
let g:goyo_width=87

" Automatically enable vim-colors-pencil colorscheme when entering goyo
function! s:goyo_enter()
        colorscheme pencil
        set guifont=Iosevka:h16
        " :set wrap
        " :set linebreak
endfunction

function! s:goyo_leave()
        colorscheme one
        set guifont=Iosevka:h12
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" -----------------------------------------------------------------------------
" stsewd/fzf-checkout.vim
" -----------------------------------------------------------------------------

" Checkout a branch
"nnoremap <silent> <leader>gc :GCheckout<CR>

" -----------------------------------------------------------------------------
" junegunn/fzf
" -----------------------------------------------------------------------------

" Fzf find files
nnoremap <silent> <leader>f :GFiles<CR>
nnoremap <silent> <leader>F :call fzf#vim#files('.', {'options': '--prompt ""'})<CR>
nnoremap <silent> <leader>b :Buffers<CR>

" ,l to find lines in current file
nnoremap <silent> <leader>l :Lines<CR>

" ,: to search through :command history
nnoremap <silent> <leader>: :History:<CR>


" Floating FZF window
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
" If have Bash
"let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"
" If on Windows (don't have bash)
let $FZF_DEFAULT_COMMAND = 'dir /s/b/a:-d-ha'
let $FZF_DEFAULT_OPTS=' --color=dark --color=fg:15,bg:-1,hl:1,fg+:#ffffff,bg+:0,hl+:1 --color=info:0,prompt:0,pointer:12,marker:4,spinner:11,header:-1 --layout=reverse  --margin=1,4'
let g:fzf_layout = { 'window': 'call FloatingFZF()' }

function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, '&signcolumn', 'no')

  let height = float2nr(20)
  let width = float2nr(80)
  let horizontal = float2nr((&columns - width) / 2)
  let vertical = 1

  let opts = {
        \ 'relative': 'editor',
        \ 'row': vertical,
        \ 'col': horizontal,
        \ 'width': width,
        \ 'height': height,
        \ 'style': 'minimal'
        \ }

  call nvim_open_win(buf, v:true, opts)
endfunction

" -----------------------------------------------------------------------------
" tpope/vim-fugitive
" -----------------------------------------------------------------------------

" Used for resolving merge conflicts
nmap <leader>gh :diffget //3<CR>
nmap <leader>gu :diffget //2<CR>

nnoremap <leader>gs :G<CR>
nnoremap <leader>gd :Gvdiff<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>gr :Gread<CR>

" -----------------------------------------------------------------------------
" mhinz/vim-startify
" -----------------------------------------------------------------------------

nnoremap <leader>ss :SSave<CR>
nnoremap <leader>sc :SClose<CR>
nnoremap <leader>sd :SDelete<CR>

let g:startify_files_number = 10
let g:startify_padding_left = 5
let g:startify_session_persistence=1

" Simplify the startify list to just recent files and sessions
let g:startify_lists = [
  \ { 'type': 'dir',       'header': ['   Recent files'] },
  \ { 'type': 'sessions',  'header': ['   Saved sessions'] },
  \ ]

let g:startify_custom_header = [
    \ "\t                                   /\\ ",
    \ "\t                              /\\  //\\\\ ",
    \ "\t                       /\\    //\\\\///\\\\\\        /\\ ",
    \ "\t                      //\\\\  ///\\////\\\\\\\\  /\\  //\\\\ ",
    \ "\t         /\\          /  ^ \\/^ ^/^  ^  ^ \\/^ \\/  ^ \\ ",
    \ "\t        / ^\\    /\\  / ^   /  ^/ ^ ^ ^   ^\\ ^/  ^^  \\ ",
    \ "\t       /^   \\  / ^\\/ ^ ^   ^ / ^  ^    ^  \\/ ^   ^  \\       * ",
    \ "\t      /  ^ ^ \\/^  ^\\ ^ ^ ^   ^  ^   ^   ____  ^   ^  \\     /|\\ ",
    \ "\t     / ^ ^  ^ \\ ^  _\\___________________|  |_____^ ^  \\   /||o\\ ",
    \ "\t    / ^^  ^ ^ ^\\  /______________________________\\ ^ ^ \\ /|o|||\\ ",
    \ "\t   /  ^  ^^ ^ ^  /________________________________\\  ^  /|||||o|\\ ",
    \ "\t  /^ ^  ^ ^^  ^    ||___|___||||||||||||___|__|||      /||o||||||\\       | ",
    \ "\t / ^   ^   ^    ^  ||___|___||||||||||||___|__|||          | |           | ",
    \ "\t/ ^ ^ ^  ^  ^  ^   ||||||||||||||||||||||||||||||oooooooooo| |ooooooo  | ",
    \ "\tooooooooooooooooooooooooooooooooooooooooooooooooooooooooo ",
    \  ]
