-- ----------------------------------------------------------------------
-- --                           Normal Mode                            --
-- ----------------------------------------------------------------------
-- vim.api.nvim_set_keymap('n', 'j', 'gj', { silent = true, noremap = true }) -- Move by one line
-- vim.api.nvim_set_keymap('n', 'k', 'gk', { silent = true, noremap = true }) -- Move by one line
-- vim.api.nvim_set_keymap('n', 'Y', 'yg_', { silent = true, noremap = true }) -- Yank til end of line
-- vim.api.nvim_set_keymap('n', 'J', 'mzJ`z', { silent = true, noremap = true }) -- Keep screen centered
-- vim.api.nvim_set_keymap('n', 'n', 'nzzzv', { silent = true, noremap = true }) -- Keep screen centered
-- vim.api.nvim_set_keymap('n', 'N', 'Nzzzv', { silent = true, noremap = true }) -- Keep screen centered
-- vim.api.nvim_set_keymap('n', 'gx', [[mzyiW:!open "<c-r><c-a>"<cr>`z]], { silent = true, noremap = true }) -- Use gx to open URL under cursor (won't work with hashtags)
-- vim.api.nvim_set_keymap(
--     'n',
--     '<leader>lspinstall',
--     [[:LspInstall bashls dockerls gopls html jsonls pyright rust_analyzer sumneko_lua terraformls tsserver vimls yamlls sqls<CR>]],
--     { silent = true, noremap = true }
-- )
-- vim.api.nvim_set_keymap(
--     'n',
--     '<leader>ht',
--     [[ :lua require("harpoon.ui").toggle_quick_menu()<CR>ggVGcmain.tf<ESC>oterraform.tfvars<ESC>ovariables.tf<ESC>obackend.tfvars<ESC> ]],
--     { silent = true, noremap = true }
-- ) -- Load harpoon with terraform files
-- vim.api.nvim_set_keymap(
--     'n',
--     '<leader>ha',
--     [[:lua require("harpoon.mark").add_file()<CR>]],
--     { silent = true, noremap = true }
-- )
-- vim.api.nvim_set_keymap(
--     'n',
--     '<leader>or',
--     [[ mz?resource "<CR>yi"Ohttps://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/<ESC>pbdf_dd`z ]],
--     { silent = true, noremap = true }
-- )
-- vim.api.nvim_set_keymap('n', '<leader>b', '%', { silent = true, noremap = true })
-- vim.api.nvim_set_keymap(
--     'n',
--     '<leader>of',
--     '<CMD>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<CR>',
--     { silent = true, noremap = true }
-- )
-- vim.api.nvim_set_keymap(
--     'n',
--     '<leader>dot',
--     [[:lua require('config.telescope').search_dotfiles()<CR>]],
--     { silent = true, noremap = true }
-- )
-- vim.api.nvim_set_keymap('n', '<leader>f', ':lua vim.lsp.buf.formatting_sync()<CR>', { silent = true, noremap = true }) -- Format file
-- vim.api.nvim_set_keymap('n', '<leader>q', ':call ToggleQFList(0)<CR>', { silent = true, noremap = true })
-- vim.api.nvim_set_keymap(
--     'n',
--     '<leader>w',
--     [[:lua require('telescope').extensions.git_worktree.git_worktrees()<CR>]],
--     { silent = true, noremap = true }
-- ) -- list worktrees
-- vim.api.nvim_set_keymap(
--     'n',
--     '<leader>nw',
--     [[:lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>]],
--     { silent = true, noremap = true }
-- ) -- new worktree
-- vim.api.nvim_set_keymap('n', '<leader>tb', ':Telescope file_browser<CR><ESC>', { silent = true, noremap = true })
-- vim.api.nvim_set_keymap('n', '<leader><leader>x', ':w<CR>:source %<CR>', { silent = true, noremap = true })
-- vim.api.nvim_set_keymap('n', '<leader>on', ':e ~/neorg/notes/index.norg<CR>', { silent = true, noremap = true })
-- vim.api.nvim_set_keymap('n', '<leader>ot', ':e ~/neorg/tasks/index.norg<CR>', { silent = true, noremap = true })
-- vim.api.nvim_set_keymap('n', '<leader>oi', ':e ~/neorg/tasks/inbox.norg<CR>', { silent = true, noremap = true })
-- vim.api.nvim_set_keymap('n', '<leader>yf', [[:let @+ = expand("%")<CR>]], { silent = true, noremap = true }) -- yank file name
-- vim.api.nvim_set_keymap('n', '<leader>yp', [[:let @+ = expand("%:p")<CR>]], { silent = true, noremap = true }) -- yank file path
-- vim.api.nvim_set_keymap(
--     'n',
--     '<leader>da',
--     [[:lua require("refactoring").debug.printf({below = false})<CR>]],
--     { silent = true, noremap = true }
-- )
-- vim.api.nvim_set_keymap(
--     'n',
--     '<leader>db',
--     [[:lua require("refactoring").debug.printf({below = true})<CR>]],
--     { silent = true, noremap = true }
-- )
-- vim.api.nvim_set_keymap(
--     'n',
--     '<leader>pb',
--     [[:lua require('telescope.builtin').buffers()<CR>]],
--     { silent = true, noremap = true }
-- )
-- vim.api.nvim_set_keymap(
--     'n',
--     '<leader>pf',
--     [[:lua require('telescope.builtin').git_files()<CR>]],
--     { silent = true, noremap = true }
-- )
-- vim.api.nvim_set_keymap(
--     'n',
--     '<leader>pw',
--     [[:lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>]],
--     { silent = true, noremap = true }
-- )
-- vim.api.nvim_set_keymap(
--     'n',
--     '<leader>ps',
--     [[:lua require('telescope.builtin').live_grep()<CR>]],
--     { silent = true, noremap = true }
-- )
-- vim.api.nvim_set_keymap('n', '<leader>gp', ':Git push<CR>', { silent = true, noremap = true })
-- vim.api.nvim_set_keymap('n', '<leader>gs', ':G<CR>', { silent = true, noremap = true })
-- vim.api.nvim_set_keymap('n', '<leader>gd', ':Gvdiffsplit!<CR>', { silent = true, noremap = true }) -- open the three way merge conflict
-- vim.api.nvim_set_keymap('n', '<leader>gu', ':diffget //2<CR>', { silent = true, noremap = true }) -- :Gdiff, pull in target (current branch) changes from left
-- vim.api.nvim_set_keymap('n', '<leader>gh', ':diffget //3<CR>', { silent = true, noremap = true }) -- :Gdiff, pull in merge changes from right
-- vim.api.nvim_set_keymap(
--     'n',
--     '<leader>gc',
--     [[:lua require('config.telescope').git_branches()<CR>]],
--     { silent = true, noremap = true }
-- )
-- vim.api.nvim_set_keymap(
--     'n',
--     '<CR>',
--     [[:lua require("harpoon.ui").toggle_quick_menu()<CR>]],
--     { silent = true, noremap = true }
-- )
-- vim.api.nvim_set_keymap('n', '<C-k>', ':cnext<CR>zz', { silent = true, noremap = true })
-- vim.api.nvim_set_keymap('n', '<C-j>', ':cprev<CR>zz', { silent = true, noremap = true })
-- vim.api.nvim_set_keymap('n', '<C-q>', ':call ToggleQFList(1)<CR>', { silent = true, noremap = true })
-- vim.api.nvim_set_keymap('n', '<C-h>', [[:lua require("harpoon.ui").nav_file(1)<CR>]], {
--     silent = true,
--     noremap = true,
-- })
-- vim.api.nvim_set_keymap('n', '<C-t>', [[:lua require("harpoon.ui").nav_file(2)<CR>]], {
--     silent = true,
--     noremap = true,
-- })
-- vim.api.nvim_set_keymap('n', '<C-n>', [[:lua require("harpoon.ui").nav_file(3)<CR>]], {
--     silent = true,
--     noremap = true,
-- })
-- vim.api.nvim_set_keymap('n', '<C-s>', [[:lua require("harpoon.ui").nav_file(4)<CR>]], {
--     silent = true,
--     noremap = true,
-- })
-- vim.api.nvim_set_keymap(
--     'n',
--     '<C-g>',
--     [[:lua require("harpoon.term").gotoTerminal(1)<CR>]],
--     { silent = true, noremap = true }
-- )
-- vim.api.nvim_set_keymap(
--     'n',
--     '<C-c>',
--     [[:lua require("harpoon.term").gotoTerminal(2)<CR>]],
--     { silent = true, noremap = true }
-- )
-- -- { 'c>', [[:lua require("harpoon.term").sendCommand(1, "cargo run\n")<CR>]] },
-- -- { 'c>', [[:lua require("harpoon.term").sendCommand(1, "semgrep --config semgrep.yaml\n")<CR>]] },
-- ----------------------------------------------------------------------
-- --                           Insert Mode                            --
-- ----------------------------------------------------------------------
-- vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { silent = true, noremap = true })
-- vim.api.nvim_set_keymap('i', 'JK', '<Esc>', { silent = true, noremap = true })
-- vim.api.nvim_set_keymap('i', '!', '!<c-g>u', { silent = true, noremap = true }) -- Undo break points
-- vim.api.nvim_set_keymap('i', ',', ',<c-g>u', { silent = true, noremap = true }) -- Undo break points
-- vim.api.nvim_set_keymap('i', '.', '.<c-g>u', { silent = true, noremap = true }) -- Undo break points
-- vim.api.nvim_set_keymap('i', '?', '?<c-g>u', { silent = true, noremap = true }) -- Undo break points
-- ----------------------------------------------------------------------
-- --                           Visual Mode                            --
-- ----------------------------------------------------------------------
-- vim.api.nvim_set_keymap('x', '<leader>ol', ':GBrowse<CR>', { silent = true, noremap = true }) --  Open line(s)
-- ----------------------------------------------------------------------
-- --                      Visual and Select Mode                      --
-- ----------------------------------------------------------------------
-- vim.api.nvim_set_keymap('v', '<leader>r', [[:sno//g<left><left>]], { silent = true, noremap = true })
-- vim.api.nvim_set_keymap('v', 'J', [[:m '>+1<CR>gv=gv]], { silent = true, noremap = true }) -- Moving text
-- vim.api.nvim_set_keymap('v', 'K', [[:m '<-2<CR>gv=gv]], { silent = true, noremap = true }) -- Moving text
-- vim.api.nvim_set_keymap(
--     'v',
--     'rr',
--     [[:lua require("config.telescope").refactors()<CR>]],
--     { silent = true, noremap = true }
-- )
-- vim.api.nvim_set_keymap(
--     'v',
--     '<leader>of',
--     '<CMD>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<CR>',
--     { silent = true, noremap = true }
-- )
-- ----------------------------------------------------------------------
-- --                          Terminal Mode                           --
-- ----------------------------------------------------------------------
-- vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { silent = true, noremap = true }) --  Go into normal mode in terminal
-- vim.api.nvim_set_keymap('t', 'jk', '<C-\\><C-n>', { silent = true, noremap = true }) --  Go into normal mode in terminal
-- ----------------------------------------------------------------------
-- --                          Multiple Modes                          --
-- ----------------------------------------------------------------------
-- vim.api.nvim_set_keymap('n', '-', 'g_', { silent = true, noremap = true })
-- vim.api.nvim_set_keymap('v', '-', 'g_', { silent = true, noremap = true })
-- vim.api.nvim_set_keymap('n', '_', '^', { silent = true, noremap = true })
-- vim.api.nvim_set_keymap('v', '_', '^', { silent = true, noremap = true })
-- vim.api.nvim_set_keymap('n', '˙', '<C-W>h', { silent = true, noremap = true }) -- Alt+h | traverse splits (focus left)
-- vim.api.nvim_set_keymap('i', '˙', '<C-W>h', { silent = true, noremap = true }) -- Alt+h | traverse splits (focus left)
-- vim.api.nvim_set_keymap('v', '˙', '<C-W>h', { silent = true, noremap = true }) -- Alt+h | traverse splits (focus left)
-- vim.api.nvim_set_keymap('n', '¬', '<C-W>l', { silent = true, noremap = true }) -- Alt+l | traverse splits (focus right)
-- vim.api.nvim_set_keymap('i', '¬', '<C-W>l', { silent = true, noremap = true }) -- Alt+l | traverse splits (focus right)
-- vim.api.nvim_set_keymap('v', '¬', '<C-W>l', { silent = true, noremap = true }) -- Alt+l | traverse splits (focus right)
-- vim.api.nvim_set_keymap('n', 'ga', [[:Tabularize /]], { silent = true, noremap = true })
-- vim.api.nvim_set_keymap('v', 'ga', [[:Tabularize /]], { silent = true, noremap = true })
-- vim.api.nvim_set_keymap('n', 'ga:', [[:Tabularize /:\zs<CR>]], { silent = true, noremap = true })
-- vim.api.nvim_set_keymap('v', 'ga:', [[:Tabularize /:\zs<CR>]], { silent = true, noremap = true })
