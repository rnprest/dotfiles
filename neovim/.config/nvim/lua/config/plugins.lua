local execute = vim.api.nvim_command
local packer = nil
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local compile_path = install_path .. '/plugin/packer_compiled.lua'
local is_installed = vim.fn.empty(vim.fn.glob(install_path)) == 0

local function init()
	if not is_installed then
		if vim.fn.input('Install packer.nvim? (y for yes) ') == 'y' then
			execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
			execute('packadd packer.nvim')
			print('Installed packer.nvim.')
			is_installed = 1
		end
	end

	if not is_installed then
		return
	end
	if packer == nil then
		packer = require('packer')
		packer.init({
			disable_commands = true,
			compile_path = compile_path,
		})
	end

	local use = packer.use
	packer.reset()

	use('wbthomason/packer.nvim') -- Which came first? The chicken or the egg?
	use('lewis6991/impatient.nvim')
	use('neovim/nvim-lspconfig')
	use('godlygeek/tabular')
	use('rhysd/clever-f.vim') -- Better f-movement - repeat w/ f or F
	use('sheerun/vim-polyglot') -- Syntax and other support for almost every programming language
	use('tpope/vim-abolish') -- Coercion between snake_case, camelCase, etc. (crs & crc)
	use('tpope/vim-fugitive') -- Adds Gread, Gwrite, etc. all of which use buffer
	use('tpope/vim-repeat') -- Repeat plugins with '.'
	use('tpope/vim-surround') -- Surround words
	use('wellle/targets.vim') -- Better text object movement
	use('drewtempelmeyer/palenight.vim') -- Palenight theme
	use('iamcco/markdown-preview.nvim') -- if on M1 mac, then need to 'yarn install && yarn upgrade' inside app directory
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
				-- One of "all", "maintained" (parsers with maintainers), or a list of languages
				ensure_installed = { 'rust', 'go', 'java', 'yaml', 'json', 'lua', 'hcl', 'make' },

				-- Install languages synchronously (only applied to `ensure_installed`)
				sync_install = false,

				indent = {
					enabled = true,
				},

				highlight = {
					-- `false` will disable the whole extension
					enable = true,

					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	})
	use('nvim-treesitter/playground')
	-- Colorschemes
	use({
		'marko-cerovac/material.nvim',
		requires = { 'tjdevries/colorbuddy.nvim' },
		config = function()
			vim.cmd('colorscheme material')
			-- This highlight needs to load AFTER the colorscheme is set so that it isn't overwritten
			vim.cmd('highlight CursorLineNr guifg=#fb801a') -- current cursorline number (make it a pretty orange)
		end,
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
		'hrsh7th/nvim-cmp',
		event = 'BufEnter',
		config = function()
			require('config.cmp').setup()
		end,
	})
	use({ 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' })
	use({ 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' })
	use({ 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' })
	use({ 'hrsh7th/cmp-buffer', after = 'nvim-cmp' })
	use({ 'hrsh7th/cmp-path', after = 'nvim-cmp' })
	use({ 'onsails/lspkind-nvim' })

	use({ 'williamboman/nvim-lsp-installer', event = 'BufEnter', after = 'cmp-nvim-lsp', config = "require('config.lsp')" })

	use({ 'tami5/lspsaga.nvim', branch = 'nvim51' })
	use({ 'ray-x/lsp_signature.nvim' })

	-- luasnip ❤️   cmp
	use({ 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' })
	use({ 'L3MON4D3/LuaSnip', requires = { 'rafamadriz/friendly-snippets' }, after = 'cmp_luasnip' })
	-- Telescope
	use({
		'nvim-telescope/telescope.nvim',
		requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-fzy-native.nvim' },
		config = function()
			require('config.telescope')
		end,
	})
	-- use({ 'ThePrimeagen/git-worktree.nvim', requires = { 'nvim-telescope/telescope.nvim' } })
	use({ 'nvim-telescope/telescope-file-browser.nvim', requires = { 'nvim-telescope/telescope.nvim' } })
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
	use({
		'SmiteshP/nvim-gps',
		requires = { 'nvim-treesitter/nvim-treesitter' },
		config = function()
			require('nvim-gps').setup()
		end,
	})
	use({
		'ruifm/gitlinker.nvim',
		requires = 'nvim-lua/plenary.nvim',
		config = function()
			require('config.gitlinker')
		end,
	})
end

local plugins = setmetatable({}, {
	__index = function(_, key)
		init()
		return packer[key]
	end,
})

return plugins
