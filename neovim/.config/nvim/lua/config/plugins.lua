-- auto-install packer
local execute = vim.api.nvim_command
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path })
	execute('packadd packer.nvim')
end

-- automatically compile after changing plugins
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require('packer').startup(function()
	-- Packer can manage itself
	use('wbthomason/packer.nvim')
	use('godlygeek/tabular')
	use('rhysd/clever-f.vim') -- Better f-movement - repeat w/ f or F
	use('sheerun/vim-polyglot') -- Syntax and other support for almost every programming language
	use('tpope/vim-abolish') -- Coercion between snake_case, camelCase, etc. (crs & crc)
	use('tpope/vim-fugitive') -- Adds Gread, Gwrite, etc. all of which use buffer
	use('tpope/vim-repeat') -- Repeat plugins with '.'
	use('tpope/vim-rhubarb') -- Open github repo of current file
	use('tpope/vim-surround') -- Surround words
	use('wellle/targets.vim') -- Better text object movement
	use('ThePrimeagen/git-worktree.nvim')
	use('drewtempelmeyer/palenight.vim') -- Palenight theme
	use('iamcco/markdown-preview.nvim') -- if on M1 mac, then need to 'yarn install && yarn upgrade' inside app directory
	-- Minimap (scrolling preview pane)
	use({
		'wfxr/minimap.vim', -- requires: brew install code-minimap
		config = function()
			vim.g.minimap_width = 10
			vim.g.minimap_auto_start = 1
			vim.g.minimap_auto_start_win_enter = 1
		end,
	})
	-- Comments
	use({
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup({
				ignore = '^$',
			})
		end,
	})
	use({
		's1n7ax/nvim-comment-frame',
		requires = {
			{ 'nvim-treesitter' },
		},
		config = function()
			require('nvim-comment-frame').setup()
		end,
	})
	----------
	use({
		'windwp/nvim-autopairs',
		config = function()
			require('nvim-autopairs').setup()
		end,
	})
	use({ -- Pretty keymaps
		'LionC/nest.nvim',
		config = function()
			require('config.remaps')
		end,
	})
	use({
		'kyazdani42/nvim-web-devicons',
		config = function()
			require('nvim-web-devicons').setup()
		end,
	})
	use({
		'mhartington/formatter.nvim',
		config = function()
			require('config.formatter')
		end,
	})
	use({
		'rcarriga/nvim-notify',
		config = function()
			require('notify').setup({
				-- Animation style (see below for details)
				stages = 'fade_in_slide_out',
				-- Default timeout for notifications
				timeout = 1000,
				-- For stages that change opacity this is treated as the highlight behind the window
				-- Set this to either a highlight group or an RGB hex value e.g. "#000000"
				background_colour = 'Normal',
				-- Icons for the different levels
				icons = {
					ERROR = '',
					WARN = '',
					INFO = '',
					DEBUG = '',
					TRACE = '✎',
				},
			})
			vim.notify = require('notify')
		end,
	})
	use({
		'danymat/neogen',
		config = function()
			require('neogen').setup({
				enabled = true,
			})
		end,
		requires = 'nvim-treesitter/nvim-treesitter',
	})
	-- Translate color codes in terminal
	use({
		'norcalli/nvim-terminal.lua',
		config = function()
			require('terminal').setup()
		end,
	})
	-- Colored todo comments
	use({
		'folke/todo-comments.nvim',
		requires = 'nvim-lua/plenary.nvim',
		config = function()
			require('todo-comments').setup({})
		end,
	})
	-- Treesitter
	use({
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup({
				ensure_installed = 'maintained',
				highlight = {
					enable = true,
				},
			})
		end,
	})
	use('nvim-treesitter/playground')
	-- Colorschemes
	use({
		'marko-cerovac/material.nvim',
		requires = { 'tjdevries/colorbuddy.nvim' },
	})
	-- Statusline
	use({
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true },
		config = function()
			require('config.statusline').setup()
		end,
	})
	use('nvim-lua/lsp-status.nvim') -- Add components to show LSP Status in Status Line
	use({
		'lewis6991/gitsigns.nvim',
		requires = {
			'nvim-lua/plenary.nvim',
		},
		config = function()
			require('gitsigns').setup()
		end,
	})
	-- Code action menu with diffs
	use({
		'weilbith/nvim-code-action-menu',
		cmd = 'CodeActionMenu',
	})
	-- LSP
	use({
		'neovim/nvim-lspconfig',
		config = function()
			require('config.lsp')
		end,
	})
	use({ 'tami5/lspsaga.nvim', branch = 'nvim51' })
	use({ 'ms-jpq/coq_nvim', branch = 'coq' }) -- main one
	use({ 'ray-x/lsp_signature.nvim' })
	-- Telescope
	use({
		'nvim-telescope/telescope.nvim',
		requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-fzy-native.nvim' },
		config = function()
			require('config.telescope')
		end,
	})
	-- Telescope PROJECTS
	use({
		'ahmedkhalf/project.nvim',
		config = function()
			require('project_nvim').setup({})
		end,
	})
	-- Harpoon
	use({
		'ThePrimeagen/harpoon',
		requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
	})
	-- Task Warrior / Vim Wiki
	use({ 'vimwiki/vimwiki', branch = 'dev' })
	use('tools-life/taskwiki')
	-- Refactoring
	use({
		'ThePrimeagen/refactoring.nvim',
		requires = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
		config = function()
			require('refactoring').setup({})
		end,
	})
end)
