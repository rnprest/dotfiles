return {
	{
		'tpope/vim-fugitive',
		keys = {
			{ '<leader>gl', ':Git log --oneline<CR>', silent = true, noremap = true },
			{ '<leader>gr', ':Git rebase -i <cword><CR>', silent = true, noremap = true },
			{ '<leader>g-', ':Git stash<CR>', silent = true, noremap = true },
			{ '<leader>g+', ':Git stash pop<CR>', silent = true, noremap = true },
			{ '<leader>gp', ':Git push<CR>', silent = true, noremap = true },
			{ '<leader>gP', ':Git push -f<CR>', silent = true, noremap = true },
			{ '<leader>gs', ':G<CR>', silent = true, noremap = true },
			{ '<leader>gd', ':Gvdiffsplit!<CR>', silent = true, noremap = true }, -- open the three way merge conflict
			{ '<leader>gu', ':diffget //2<CR>', silent = true, noremap = true }, -- :Gdiff, pull in target (current branch) changes from left
			{ '<leader>gh', ':diffget //3<CR>', silent = true, noremap = true }, -- :Gdiff, pull in merge changes from right
			-- other modes
			{ '<leader>ol', ':GBrowse<CR>', silent = true, noremap = true, mode = 'x' }, -- Open line(s)
		},
	},

	{
		'lewis6991/gitsigns.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',
		},
		config = function()
			require('gitsigns').setup()
		end,
	},

	{
		'f-person/git-blame.nvim',
		config = function()
			vim.g.gitblame_set_extmark_options = {
				hl_mode = 'combine',
			}
			vim.g.gitblame_date_format = '%r'
		end,
	},

	{
		'ruifm/gitlinker.nvim',
		dependencies = 'nvim-lua/plenary.nvim',
		config = function()
			require 'config.gitlinker'
		end,
		cond = function()
			local fn = vim.fn
			local gitlinker_path = '~/dotfiles/neovim/.config/nvim/lua/config/gitlinker.lua'
			if fn.empty(fn.glob(gitlinker_path)) > 0 then
				vim.notify(
					[[
    Type :Notifications to view this message after it disappears

    Hey there! I see you've cloned my repo (and the plugins I use) - but haven't configured ruifm/gitlinker.nvim
        - I use this plugin to open local code in remote repositories
        - I don't push my gitlinker.lua file, because it has the name of my work's gitlab instance

        - To get rid of this message, either:
            - Remove the plugin
                1. Delete the use block and run :PackerClean
            - Use the plugin defaults
                1. Remove the "cond" and "config" blocks from the plugin's use block
            - Configure the plugin for your work
                1. add a gitlinker.lua with your work's gitlab instance
                2. add gitlinker.lua to your .gitignore
                3. update the gitlinker_path in the "cond" block
                            ]],
					vim.log.levels.WARN,
					{
						title = 'ruifm/gitlinker.nvim',
						timeout = 3000,
					}
				)
				return false
			end
			return true
		end,
	},
}
