local ok = pcall(require, 'impatient')
require 'config.packer_commands'

if not ok then
    require('config.plugins').sync()
end
-----------------------------------------------------------------------------
-- Additional Settings
-----------------------------------------------------------------------------
require 'config'
require 'config.globals'
-----------------------------------------------------------------------------
-- Helpers
-----------------------------------------------------------------------------
local g, opt, cmd = vim.g, vim.opt, vim.cmd
-----------------------------------------------------------------------------
-- Settings
-----------------------------------------------------------------------------
g.mapleader = ','
-----------------

local options = {
    clipboard = 'unnamedplus',
    cmdheight = 2, -- Give more space for displaying messages.
    conceallevel = 3, -- Removes square brackets from devicons
    encoding = 'UTF-8', -- Encoding
    expandtab = true, -- Turn tabs into spaces
    fileencoding = 'UTF-8', -- Encoding
    fileencodings = 'UTF-8', -- Encoding
    guifont = 'Iosevka Nerd Font Mono:h16', -- Set font for neovide and other gui editors
    hidden = true, -- Allow switching between buffers without saving
    hlsearch = false,
    ignorecase = true, -- Case insensitive searching
    inccommand = 'split', -- Live substitution with search&replace (:%s)
    lazyredraw = true, -- Speeds up scrolling
    mouse = 'a', -- Mouse support
    redrawtime = 10000,
    regexpengine = 1, -- Speeds up scrolling
    relativenumber = true,
    scrolloff = 2, -- Always show at least one line above/below the cursor.
    shiftwidth = 4, -- The number of spaces in a tab
    sidescrolloff = 5, -- Always show at least one line left/right of the cursor.
    signcolumn = 'yes', -- Always show the signcolumn, otherwise it would shift for diagnostics
    smartcase = true, -- Will automatically switch to case sensitive if you use any capitals
    softtabstop = 4, -- Use 4 spaces for a tab
    splitbelow = true, -- Open vertical splits BELOW current buffer
    splitright = true, -- Open horizontal splits RIGHT of current buffer
    tabstop = 4,
    termguicolors = true, -- Enable 24-bit true colors
    updatetime = 100, -- default updatetime 4000ms is not good for async update (vim/signify)
    wrap = false, -- Disable soft wrapping
}
for k, v in pairs(options) do
    opt[k] = v
end
-------------------------------------------------------------------------------
-- Color settings
-------------------------------------------------------------------------------
cmd 'let $NVIM_TUI_ENABLE_TRUE_COLOR=1'
cmd 'syntax enable'
cmd 'syntax sync fromstart'
cmd 'filetype plugin on'
-------------------------------------------------------------------------------
-- Tekton Pipeline
-------------------------------------------------------------------------------
vim.cmd [[
    command! -nargs=* TknMinglePipeline lua require'tekton'.start_mingle_pipeline(<f-args>)
]]
-------------------------------------------------------------------------------
-- vimwiki
-------------------------------------------------------------------------------
g.vimwiki_list = { { path = '~/vimwiki/', syntax = 'markdown', ext = '.md' } }
g.taskwiki_dont_fold = 'yes'
