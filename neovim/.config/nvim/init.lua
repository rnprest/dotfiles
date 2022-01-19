-----------------------------------------------------------------------------
-- Additional Settings
-----------------------------------------------------------------------------
require('config')
-----------------------------------------------------------------------------
-- Helpers
-----------------------------------------------------------------------------
local g, opt, cmd, api = vim.g, vim.opt, vim.cmd, vim.api
-----------------------------------------------------------------------------
-- Settings
-----------------------------------------------------------------------------
g.mapleader = ','
-----------------
-- Right now, this setting interferes with harpoon
-- opt.autochdir = true -- Set CWD automatically when changing buffers
opt.clipboard:append('unnamedplus')
opt.cmdheight = 2 -- Give more space for displaying messages.
opt.conceallevel = 3 -- Removes square brackets from devicons
opt.encoding = 'UTF-8' -- Encoding
opt.errorbells = false
opt.expandtab = true -- Turn tabs into spaces
opt.fileencoding = 'UTF-8' -- Encoding
opt.fileencodings = 'UTF-8' -- Encoding
opt.hidden = true -- Allow switching between buffers without saving
opt.hlsearch = false
opt.ignorecase = true -- Case insensitive searching
opt.inccommand = 'split' -- Live substitution with search&replace (:%s)
opt.lazyredraw = true -- Speeds up scrolling
opt.mouse = 'a' -- Mouse support
opt.redrawtime = 10000
opt.regexpengine = 1 -- Speeds up scrolling
opt.relativenumber = true
opt.scrolloff = 2 -- Always show at least one line above/below the cursor.
opt.shiftwidth = 4 -- The number of spaces in a tab
opt.shortmess:append('c')
opt.sidescrolloff = 5 -- Always show at least one line left/right of the cursor.
opt.smartcase = true -- Will automatically switch to case sensitive if you use any capitals
opt.softtabstop = 4 -- Use 4 spaces for a tab
opt.splitbelow = true -- Open vertical splits BELOW current buffer
opt.splitright = true -- Open horizontal splits RIGHT of current buffer
opt.tabstop = 4
opt.updatetime = 100 -- default updatetime 4000ms is not good for async update (vim/signify)
opt.wrap = false -- Disable soft wrapping
opt.matchpairs:append('<:>')
opt.termguicolors = true -- Enable 24-bit true colors
opt.guifont = 'Iosevka Nerd Font Mono:h16' -- Set font for neovide and other gui editors
opt.signcolumn = 'yes' -- Always show the signcolumn, otherwise it would shift for diagnostics
-------------------------------------------------------------------------------
-- Color settings
-------------------------------------------------------------------------------
cmd('colorscheme material')
cmd('let $NVIM_TUI_ENABLE_TRUE_COLOR=1') -- Enable true colors
cmd('syntax enable')
cmd('syntax sync fromstart')
cmd('filetype plugin on')
cmd('highlight CursorLineNr guifg=#fb801a') -- current cursorline number (make it a pretty orange)
-------------------------------------------------------------------------------
-- Tekton Pipeline
-------------------------------------------------------------------------------
vim.cmd([[
    command! -nargs=* TknMinglePipeline lua require'tekton'.start_mingle_pipeline(<f-args>)
]])
-------------------------------------------------------------------------------
-- vimwiki
-------------------------------------------------------------------------------
g.vimwiki_list = { { path = '~/vimwiki/', syntax = 'markdown', ext = '.md' } }
g.taskwiki_dont_fold = 'yes'
