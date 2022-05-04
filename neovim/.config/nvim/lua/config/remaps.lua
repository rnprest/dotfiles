----------------------------------------------------------------------
--                           Normal Mode                            --
----------------------------------------------------------------------
vim.keymap.set('n', 'j', 'gj') -- Move by one line
vim.keymap.set('n', 'k', 'gk') -- Move by one line
vim.keymap.set('n', 'Y', 'yg_') -- Yank til end of line
vim.keymap.set('n', 'J', 'mzJ`z') -- Keep screen centered
vim.keymap.set('n', 'n', 'nzzzv') -- Keep screen centered
vim.keymap.set('n', 'N', 'Nzzzv') -- Keep screen centered
vim.keymap.set('n', 'gx', [[mzyiW:!open "<c-r><c-a>"<cr>`z]]) -- Use gx to open URL under cursor (won't work with hashtags)
vim.keymap.set(
    'n',
    '<leader>lspinstall',
    [[:LspInstall bashls dockerls gopls html jsonls pyright rust_analyzer sumneko_lua terraformls tsserver vimls yamlls sqls<CR>]]
)
vim.keymap.set(
    'n',
    '<leader>ht',
    [[ :lua require("harpoon.ui").toggle_quick_menu()<CR>ggVGcmain.tf<ESC>oterraform.tfvars<ESC>ovariables.tf<ESC>obackend.tfvars<ESC> ]]
) -- Load harpoon with terraform files
vim.keymap.set('n', '<leader>ha', [[:lua require("harpoon.mark").add_file()<CR>]])
vim.keymap.set(
    'n',
    '<leader>or',
    [[ mz?resource "<CR>yi"Ohttps://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/<ESC>pbdf_dd`z ]]
)
vim.keymap.set('n', '<leader>b', '%')
vim.keymap.set(
    'n',
    '<leader>of',
    '<CMD>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<CR>'
)
vim.keymap.set('n', '<leader>dot', [[:lua require('config.telescope').search_dotfiles()<CR>]])
vim.keymap.set('n', '<leader>f', ':lua vim.lsp.buf.formatting_sync()<CR>') -- Format file
vim.keymap.set('n', '<leader>q', ':call ToggleQFList(0)<CR>')
vim.keymap.set('n', '<leader>w', [[:lua require('telescope').extensions.git_worktree.git_worktrees()<CR>]]) -- list worktrees
vim.keymap.set('n', '<leader>nw', [[:lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>]]) -- new worktree
vim.keymap.set('n', '<leader>tb', ':Telescope file_browser<CR><ESC>')
vim.keymap.set('n', '<leader><leader>x', ':w<CR>:source %<CR>')
vim.keymap.set('n', '<leader>on', ':e ~/neorg/notes/index.norg<CR>')
vim.keymap.set('n', '<leader>ot', ':e ~/neorg/tasks/index.norg<CR>')
vim.keymap.set('n', '<leader>oi', ':e ~/neorg/tasks/inbox.norg<CR>')
vim.keymap.set('n', '<leader>yf', [[:let @+ = expand("%")<CR>]]) -- yank file name
vim.keymap.set('n', '<leader>yp', [[:let @+ = expand("%:p")<CR>]]) -- yank file path
vim.keymap.set('n', '<leader>da', [[:lua require("refactoring").debug.printf({below = false})<CR>]])
vim.keymap.set('n', '<leader>db', [[:lua require("refactoring").debug.printf({below = true})<CR>]])
vim.keymap.set('n', '<leader>pb', [[:lua require('telescope.builtin').buffers()<CR>]])
vim.keymap.set('n', '<leader>pf', [[:lua require('telescope.builtin').git_files()<CR>]])
vim.keymap.set(
    'n',
    '<leader>pw',
    [[:lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>]]
)
vim.keymap.set('n', '<leader>ps', [[:lua require('telescope.builtin').live_grep()<CR>]])
vim.keymap.set('n', '<leader>gp', ':Git push<CR>')
vim.keymap.set('n', '<leader>gs', ':G<CR>')
vim.keymap.set('n', '<leader>gd', ':Gvdiffsplit!<CR>') -- open the three way merge conflict
vim.keymap.set('n', '<leader>gu', ':diffget //2<CR>') -- :Gdiff, pull in target (current branch) changes from left
vim.keymap.set('n', '<leader>gh', ':diffget //3<CR>') -- :Gdiff, pull in merge changes from right
vim.keymap.set('n', '<leader>gc', [[:lua require('config.telescope').git_branches()<CR>]])
vim.keymap.set('n', '<CR>', [[:lua require("harpoon.ui").toggle_quick_menu()<CR>]])
vim.keymap.set('n', '<leader><C-k>', ':cnext<CR>zz')
vim.keymap.set('n', '<leader><C-j>', ':cprev<CR>zz')
vim.keymap.set('n', '<leader><C-q>', ':call ToggleQFList(1)<CR>')
vim.keymap.set('n', '<leader><C-h>', [[:lua require("harpoon.ui").nav_file(1)<CR>]])
vim.keymap.set('n', '<leader><C-t>', [[:lua require("harpoon.ui").nav_file(2)<CR>]])
vim.keymap.set('n', '<leader><C-n>', [[:lua require("harpoon.ui").nav_file(3)<CR>]])
vim.keymap.set('n', '<leader><C-s>', [[:lua require("harpoon.ui").nav_file(4)<CR>]])
vim.keymap.set('n', '<leader><C-g>', [[:lua require("harpoon.term").gotoTerminal(1)<CR>]])
vim.keymap.set('n', '<leader><C-c>', [[:lua require("harpoon.term").gotoTerminal(2)<CR>]])
-- { 'c>', [[:lua require("harpoon.term").sendCommand(1, "cargo run\n")<CR>]] },
-- { 'c>', [[:lua require("harpoon.term").sendCommand(1, "semgrep --config semgrep.yaml\n")<CR>]] },
----------------------------------------------------------------------
--                           Insert Mode                            --
----------------------------------------------------------------------
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('i', 'JK', '<Esc>')
vim.keymap.set('i', '!', '!<c-g>u') -- Undo break points
vim.keymap.set('i', ',', ',<c-g>u') -- Undo break points
vim.keymap.set('i', '.', '.<c-g>u') -- Undo break points
vim.keymap.set('i', '?', '?<c-g>u') -- Undo break points
----------------------------------------------------------------------
--                           Visual Mode                            --
----------------------------------------------------------------------
vim.keymap.set('x', '<leader>ol', ':GBrowse<CR>') --  Open line(s)
----------------------------------------------------------------------
--                      Visual and Select Mode                      --
----------------------------------------------------------------------
vim.keymap.set('v', '<leader>r', [[:sno//g<left><left>]])
vim.keymap.set('v', 'J', [[:m '>+1<CR>gv=gv]]) -- Moving text
vim.keymap.set('v', 'K', [[:m '<-2<CR>gv=gv]]) -- Moving text
vim.keymap.set('v', 'rr', [[:lua require("config.telescope").refactors()<CR>]])
vim.keymap.set(
    'v',
    '<leader>of',
    '<CMD>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<CR>'
)
----------------------------------------------------------------------
--                          Terminal Mode                           --
----------------------------------------------------------------------
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>') --  Go into normal mode in terminal
vim.keymap.set('t', 'jk', '<C-\\><C-n>') --  Go into normal mode in terminal
----------------------------------------------------------------------
--                          Multiple Modes                          --
----------------------------------------------------------------------
vim.keymap.set({ 'n', 'v' }, '-', 'g_')
vim.keymap.set({ 'n', 'v' }, '_', '^')
vim.keymap.set({ 'n', 'i', 'v' }, '˙', '<C-W>h') -- Alt+h | traverse splits (focus left)
vim.keymap.set({ 'n', 'i', 'v' }, '¬', '<C-W>l') -- Alt+l | traverse splits (focus right)
vim.keymap.set({ 'n', 'v' }, 'ga', [[:Tabularize /]])
vim.keymap.set({ 'n', 'v' }, 'ga:', [[:Tabularize /:\zs<CR>]])
