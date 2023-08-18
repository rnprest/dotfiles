-- Additional Settings
-----------------------------------------------------------------------------
require 'config'
require 'config.globals'
require 'config.macros'
-----------------------------------------------------------------------------
-- Helpers
-----------------------------------------------------------------------------
local g, opt, cmd = vim.g, vim.opt, vim.cmd
-----------------------------------------------------------------------------
-- Settings
-----------------------------------------------------------------------------
local options = {
    clipboard = 'unnamedplus',
    cmdheight = 2, -- Give more space for displaying messages.
    concealcursor = 'nc', -- conceal links for orgmode
    conceallevel = 2, -- conceal links for orgmode
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
    swapfile = false,
    tabstop = 4,
    termguicolors = true, -- Enable 24-bit true colors
    textwidth = 80,
    updatetime = 100, -- default updatetime 4000ms is not good for async update (vim/signify)
    wrap = false, -- Disable soft wrapping
}
for k, v in pairs(options) do
    opt[k] = v
end

opt.formatoptions = opt.formatoptions
    + 'c' -- In general, I like it when comments respect textwidth
    + 'j' -- Auto-remove comments if possible.
    + 'n' -- Indent past the formatlistpat, not underneath it.
    + 'q' -- Allow formatting comments w/ gq
    + 'r' -- But do continue when pressing enter.
    - '2' -- I'm not in gradeschool anymore
    - 'a' -- Auto formatting is BAD.
    - 'o' -- O and o, don't continue comments
    - 't' -- Don't auto format my code. I got linters for that.
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
-- Special Search (:SS ^abc/def\[ghi\]x*y)
-------------------------------------------------------------------------------
vim.cmd [[
    command! -nargs=1 SS let @/ = '\V'.escape(<q-args>, '\')
]]
-------------------------------------------------------------------------------
-- Remove windows line endings (^M)
-------------------------------------------------------------------------------
vim.cmd [[
    command! RemoveWindowsLineEndings :%s/\r//g
]]
-------------------------------------------------------------------------------

--
-- ▀███▀▀▀██▄
--   ██   ▀██▄
--   ██   ▄██   ▄▄█▀██▀████████▄█████▄  ▄█▀██▄ ▀████████▄ ▄██▀███
--   ███████   ▄█▀   ██ ██    ██    ██ ██   ██   ██   ▀██ ██   ▀▀
--   ██  ██▄   ██▀▀▀▀▀▀ ██    ██    ██  ▄█████   ██    ██ ▀█████▄
--   ██   ▀██▄ ██▄    ▄ ██    ██    ██ ██   ██   ██   ▄██ █▄   ██
-- ▄████▄ ▄███▄ ▀█████▀████  ████  ████▄████▀██▄ ██████▀  ██████▀
--                                               ██
--                                             ▄████▄
----------------------------------------------------------------------
--                           Normal Mode                            --
----------------------------------------------------------------------

-- ignore mouse completely (so that wezterm can correctly open hyperlinks)
vim.cmd [[
  set mouse=
]]
vim.api.nvim_set_keymap('n', 'j', 'gj', { silent = true, noremap = true }) -- Move by one line
vim.api.nvim_set_keymap('n', 'k', 'gk', { silent = true, noremap = true }) -- Move by one line
vim.api.nvim_set_keymap('n', 'Y', 'yg_', { silent = true, noremap = true }) -- Yank til end of line
vim.api.nvim_set_keymap('v', 'y', 'ygv<Esc>', { silent = true, noremap = true }) -- Move cursor to bottom after yank (can quickly paste)
vim.api.nvim_set_keymap('n', 'J', 'mzJ`z', { silent = true, noremap = true }) -- Keep screen centered
vim.api.nvim_set_keymap('n', 'n', 'nzzzv', { silent = true, noremap = true }) -- Keep screen centered
vim.api.nvim_set_keymap('n', 'N', 'Nzzzv', { silent = true, noremap = true }) -- Keep screen centered
vim.api.nvim_set_keymap('n', 'gx', [[mzyiW:!open "<c-r><c-a>"<cr>`z]], { silent = true, noremap = true }) -- Use gx to open URL under cursor (won't work with hashtags)
vim.api.nvim_set_keymap('n', '<leader>b', '%', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<leader><leader>tf', ':!terraform fmt .<CR>', { silent = true, noremap = true }) -- Format file
vim.api.nvim_set_keymap(
    'n',
    '<leader>f',
    ':lua vim.lsp.buf.format({ timeout_ms = 5000 })<CR>',
    { silent = true, noremap = true }
) -- Format file
vim.api.nvim_set_keymap(
    'n',
    '<leader>of',
    '<CMD>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<CR>',
    { silent = true, noremap = true }
)
vim.api.nvim_set_keymap('n', '<leader><leader>x', ':w<CR>:source %<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<leader>yf', [[:let @+ = expand("%")<CR>]], { silent = true, noremap = true }) -- yank file name
vim.api.nvim_set_keymap('n', '<leader>yp', [[:let @+ = expand("%:p")<CR>]], { silent = true, noremap = true }) -- yank file path
vim.api.nvim_set_keymap('n', '<C-k>', ':cnext<CR>zz', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<C-j>', ':cprev<CR>zz', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<C-q>', ':ToggleQFList<CR>', { silent = true, noremap = true })
----------------------------------------------------------------------
--                              Macros                              --
----------------------------------------------------------------------
-- Remove empty lines from visual selection
vim.api.nvim_set_keymap(
    'n',
    '<leader>mw',
    [[gv:g/^$/d
    ]],
    { silent = true, noremap = true }
)
----------------------------------------------------------------------
--                           Insert Mode                            --
----------------------------------------------------------------------
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('i', 'JK', '<Esc>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('i', '!', '!<c-g>u', { silent = true, noremap = true }) -- Undo break points
vim.api.nvim_set_keymap('i', ',', ',<c-g>u', { silent = true, noremap = true }) -- Undo break points
vim.api.nvim_set_keymap('i', '.', '.<c-g>u', { silent = true, noremap = true }) -- Undo break points
vim.api.nvim_set_keymap('i', '?', '?<c-g>u', { silent = true, noremap = true }) -- Undo break points
----------------------------------------------------------------------
--                      Visual and Select Mode                      --
----------------------------------------------------------------------
vim.api.nvim_set_keymap('v', '<leader>r', [[:sno//ge<left><left><left>]], { silent = true, noremap = true })
-- vim.api.nvim_set_keymap('v', 'J', [[:m '>+1<CR>gv=gv]], { silent = true, noremap = true }) -- Moving text
-- vim.api.nvim_set_keymap('v', 'K', [[:m '<-2<CR>gv=gv]], { silent = true, noremap = true }) -- Moving text
vim.api.nvim_set_keymap(
    'v',
    '<leader>of',
    '<CMD>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<CR>',
    { silent = true, noremap = true }
)
----------------------------------------------------------------------
--                          Terminal Mode                           --
----------------------------------------------------------------------
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { silent = true, noremap = true }) --  Go into normal mode in terminal
vim.api.nvim_set_keymap('t', 'jk', '<C-\\><C-n>', { silent = true, noremap = true }) --  Go into normal mode in terminal
----------------------------------------------------------------------
--                          Multiple Modes                          --
----------------------------------------------------------------------
vim.api.nvim_set_keymap('n', '-', 'g_', { silent = true, noremap = true })
vim.api.nvim_set_keymap('v', '-', 'g_', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '_', '^', { silent = true, noremap = true })
vim.api.nvim_set_keymap('v', '_', '^', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<C-W>', '<C-W><C-W>', { silent = true, noremap = true }) -- rotate through splits
vim.api.nvim_set_keymap('i', '<C-W>', '<C-W><C-W>', { silent = true, noremap = true }) -- rotate through splits
vim.api.nvim_set_keymap('v', '<C-W>', '<C-W><C-W>', { silent = true, noremap = true }) -- rotate through splits
-- vim.api.nvim_set_keymap('n', '<C-f>', [[[s1z=<c-o>]], { silent = true, noremap = true }) -- Fix spelling mistakes
vim.api.nvim_set_keymap('i', '<C-f>', [[<c-g>u<Esc>[s1z=`]a<c-g>u]], { silent = true, noremap = true }) -- Fix spelling mistakes
vim.api.nvim_set_keymap('n', '<leader>jp', ':%!jq<CR>', { silent = true, noremap = true }) -- prettify json
vim.api.nvim_set_keymap('v', '<leader>jp', ':%!jq<CR>', { silent = true, noremap = true }) -- prettify json
vim.api.nvim_set_keymap('n', '<leader>jm', ':%!jq -c<CR>', { silent = true, noremap = true }) -- minify json
vim.api.nvim_set_keymap('v', '<leader>jm', ':%!jq -c<CR>', { silent = true, noremap = true }) -- minify json
----------------------------------------------------------------------
--                           Autocommands                           --
----------------------------------------------------------------------
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
----------------------------------------------------------------------
--                          Skeleton Files                          --
----------------------------------------------------------------------
local skeleton_group = augroup('SpookyScarySkeletons', {})
autocmd('BufNewFile', {
    group = skeleton_group,
    pattern = '*.c',
    callback = function()
        cmd '0r ~/.config/nvim/templates/skeleton.c'
    end,
})
autocmd('BufNewFile', {
    group = skeleton_group,
    pattern = '*.cpp',
    callback = function()
        cmd '0r ~/.config/nvim/templates/skeleton.cpp'
    end,
})
autocmd('BufNewFile', {
    group = skeleton_group,
    pattern = '*.java',
    callback = function()
        cmd '0r ~/.config/nvim/templates/skeleton.java'
    end,
})
autocmd('BufNewFile', {
    group = skeleton_group,
    pattern = '*.py',
    callback = function()
        cmd '0r ~/.config/nvim/templates/skeleton.py'
    end,
})
autocmd('BufNewFile', {
    group = skeleton_group,
    pattern = '*.sh',
    callback = function()
        cmd '0r ~/.config/nvim/templates/skeleton.sh'
    end,
})
autocmd('BufNewFile', {
    group = skeleton_group,
    pattern = 'main.rs',
    callback = function()
        cmd '0r ~/.config/nvim/templates/skeleton.rs'
    end,
})
autocmd('BufNewFile', {
    group = skeleton_group,
    pattern = '*.go',
    callback = function()
        cmd '0r ~/.config/nvim/templates/skeleton.go'
    end,
})
autocmd('BufNewFile', {
    group = skeleton_group,
    pattern = 'readme.md',
    callback = function()
        cmd '0r ~/.config/nvim/templates/skeleton.md'
    end,
})

----------------------------------------------------------------------
--         Switch between line number styles when switching         --
--                              modes                               --
----------------------------------------------------------------------
local numbertoggle_group = augroup('numbertoggle', {})

autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave' }, {
    group = numbertoggle_group,
    pattern = '*',
    callback = function()
        opt.relativenumber = true
        opt.number = true
    end,
})
autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter' }, {
    group = numbertoggle_group,
    pattern = '*',
    callback = function()
        opt.relativenumber = false
        opt.number = true
    end,
})

----------------------------------------------------------------------
--              QuickFix List (toggle open and close)               --
----------------------------------------------------------------------
g.config_global_list = 0
vim.api.nvim_create_user_command('ToggleQFList', function()
    if g.config_global_list == 1 then
        g.config_global_list = 0
        cmd 'cclose'
    else
        g.config_global_list = 1
        cmd 'copen'
    end
end, {})

----------------------------------------------------------------------
--                          Highlight Yank                          --
----------------------------------------------------------------------
local yank_group = augroup('yank', {})
autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank {
            higroup = 'IncSearch',
            timeout = 200,
        }
    end,
})

----------------------------------------------------------------------
--         Removes whitespace every time the file is saved          --
----------------------------------------------------------------------
local formatting_group = augroup('formatting', {})
autocmd('BufWritePre', {
    group = formatting_group,
    pattern = '*',
    command = '%s/\\s\\+$//e',
})

----------------------------------------------------------------------
--            Set spellcheck for markdown and gitcommit             --
----------------------------------------------------------------------
local spellcheck_group = augroup('spellcheck', {})
autocmd('FileType', {
    group = spellcheck_group,
    pattern = 'markdown',
    callback = function()
        opt.spell = true
    end,
})
autocmd('FileType', {
    group = spellcheck_group,
    pattern = 'gitcommit',
    callback = function()
        opt.spell = true
        vim.bo.textwidth = 72
    end,
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    callback = function()
        local ft = vim.bo.filetype
        if ft == 'markdown' or ft == 'gitcommit' then
            return
        end
        opt.spell = false
    end,
})
