-----------------------------------------------------------------------------
-- Mappings
-----------------------------------------------------------------------------
local nest = require('nest')
nest.applyKeymaps({
	-----------------------------------------------------------------------------
	-- Normal Mode
	-----------------------------------------------------------------------------
	{ 'j', 'gj' }, -- Move by one line
	{ 'k', 'gk' }, -- Move by one line
	{ 'Y', 'yg_' }, -- Yank til end of line
	{ 'J', 'mzJ`z' }, -- Keep screen centered
	{ 'n', 'nzzzv' }, -- Keep screen centered
	{ 'N', 'Nzzzv' }, -- Keep screen centered
	{ 'gx', [[mzyiW:!open "<c-r><c-a>"<cr>`z]] }, -- Use gx to open URL under cursor (won't work with hashtags)
	-- { 'gx', [[:GBrowse "<c-r><c-a>"<CR>]] }, -- Use gx to open URL under cursor
	{
		'<leader>',
		{
			{
				'lspinstall',
				[[:LspInstall bashls dockerls gopls html jsonls pyright rust_analyzer sumneko_lua terraformls tsserver vimls yamlls<CR>]],
			},

			{ 'ha', [[:lua require("harpoon.mark").add_file()<CR>]] },
			-- saves the URL to the current resource block's azurerm docs page to the clipboard
			{ 'or', [[ mz?resource "<CR>yi"Ohttps://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/<ESC>pbdf_dd`z ]] },
			{ 'b', '%' },
			{ 'of', ':GBrowse<CR>' }, -- Open file
			{ 'dot', [[:lua require('config.telescope').search_dotfiles()<CR>]] },
			{ 'f', ':Format<CR>' }, -- Format file
			{ 'k', ':lnext<CR>zz' },
			{ 'j', ':lprev<CR>zz' },
			{ 'q', ':call ToggleQFList(0)<CR>' },
			-- { 'q', [[:call ToggleQFList(1)<CR>]] },
			-- list worktrees
			{ 'w', [[:lua require('telescope').extensions.git_worktree.git_worktrees()<CR>]] },
			-- new worktree
			{ 'nw', [[:lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>]] },
			-----------------
			{
				'y',
				{
					{ 'f', [[:let @+ = expand("%")<CR>]] }, -- yank file name
					{ 'p', [[:let @+ = expand("%:p")<CR>]] }, -- yank file path
				},
			},
			{
				'd',
				{
					{ 'a', [[:lua require("refactoring").debug.printf({below = false})<CR>]] },
					{ 'b', [[:lua require("refactoring").debug.printf({below = true})<CR>]] },
				},
			},
			{
				'p',
				{
					{ 'b', [[:lua require('telescope.builtin').buffers()<CR>]] },
					{ 'f', [[:lua require('telescope.builtin').git_files()<CR>]] },
					{
						'w',
						[[:lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>]],
					},
					{ 's', [[:lua require('telescope.builtin').live_grep()<CR>]] },
				},
			},
			{
				'g',
				{
					{ 'p', ':Git push<CR>' },
					{ 's', ':G<CR>' },
					{ 'c', [[:lua require('config.telescope').git_branches()<CR>]] },
				},
			},
			{
				's',
				{
					{ 'r', [[<Plug>SnipRun]] },
					{ 'c', [[<Plug>SnipClose]] },
				},
			},
			-- These are saved macros
			{
				'm',
				{
					{ 'p', [[:sno/mingle/${var.prefix}<CR>]] }, --  mingle --  > ${var.prefix}
					{ 's', [[:sno/dev6/${var.suffix}<CR>]] }, --  dev6   --  > ${var.suffix}
					-- FIXME: This macro doesn't work?? But it works if you copy it to clip and paste in command mode
					{ 'rcc', [[:%s/\\[[0-9]\+m//g<CR>]] }, --  Remove color codes from buffer (^[[33m, etc.)
				},
			},
		},
	},
	{
		'<C-',
		{
			{ 'k>', ':cnext<CR>zz' },
			{ 'j>', ':cprev<CR>zz' },
			{ 'q>', ':call ToggleQFList(1)<CR>' },
			{ 'm>', [[:lua require("harpoon.ui").toggle_quick_menu()<CR>]] },
			{ 'h>', [[:lua require("harpoon.ui").nav_file(1)<CR>]] },
			{ 't>', [[:lua require("harpoon.ui").nav_file(2)<CR>]] },
			{ 'n>', [[:lua require("harpoon.ui").nav_file(3)<CR>]] },
			{ 's>', [[:lua require("harpoon.ui").nav_file(4)<CR>]] },
			{ 'g>', [[:lua require("harpoon.term").gotoTerminal(1)<CR>]] },
			{ 'c>', [[:lua require("harpoon.term").sendCommand(1, "cargo run\n")<CR>]] },
			-- { 'c>', [[:lua require("harpoon.term").sendCommand(1, "semgrep --config semgrep.yaml\n")<CR>]] },
		},
	},
	-----------------------------------------------------------------------------
	-- Insert Mode
	-----------------------------------------------------------------------------
	{
		mode = 'i',
		{
			{ 'jk', '<Esc>' },
			{ 'JK', '<Esc>' },
			{ '!', '!<c-g>u' }, -- Undo break points
			{ ',', ',<c-g>u' }, -- Undo break points
			{ '.', '.<c-g>u' }, -- Undo break points
			{ '?', '?<c-g>u' }, -- Undo break points
			{ '<C-l>', [[<c-g>u<Esc>[s1z=`]a<c-g>u]] }, -- Go back to last misspelled word and pick first suggestion.
		},
	},

	-----------------------------------------------------------------------------
	-- Visual Mode
	-----------------------------------------------------------------------------
	{
		mode = 'x',
		{
			{ '<leader>ol', ':GBrowse<CR>' }, --  Open line(s)
		},
	},
	-----------------------------------------------------------------------------
	-- Visual (and Select) Mode
	-----------------------------------------------------------------------------
	{
		mode = 'v',
		{
			{ 'J', [[:m '>+1<CR>gv=gv]] }, -- Moving text
			{ 'K', [[:m '<-2<CR>gv=gv]] }, -- Moving text
			{ 'rr', [[:lua require("config.telescope").refactors()<CR>]] },
		},
	},
	-----------------------------------------------------------------------------
	-- Terminal Mode
	-----------------------------------------------------------------------------
	{
		mode = 't',
		{
			{ '<Esc>', '<C-\\><C-n>' }, --  Go into normal mode in terminal
			{ 'jk', '<C-\\><C-n>' }, --  Go into normal mode in terminal
		},
	},
	-----------------------------------------------------------------------------
	-- Multiple Modes
	-----------------------------------------------------------------------------
	{ '-', 'g_', mode = 'nv' },
	{ '_', '^', mode = 'nv' },
	{ '˙', '<C-W>h', mode = 'niv' }, -- Alt+h | traverse splits (focus left)
	{ '¬', '<C-W>l', mode = 'niv' }, -- Alt+l | traverse splits (focus right)
	{ 'ga', [[:Tabularize /]], mode = 'nv' },
	{ 'ga:', [[:Tabularize /:\zs<CR>]], mode = 'nv' },
})
