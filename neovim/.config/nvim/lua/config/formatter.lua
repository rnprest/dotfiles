--------------------------------------------------------------------------------
-- Formatter
--------------------------------------------------------------------------------
require('formatter').setup({
	logging = false,
	filetype = {
		sh = {
			-- Shell Script Formatter
			function()
				return {
					exe = 'shfmt',
					args = { '-i', 2 },
					stdin = true,
				}
			end,
		},
		python = {
			-- Configuration for psf/black
			function()
				return {
					exe = 'black', -- this should be available on your $PATH
					args = { '-' },
					stdin = true,
				}
			end,
		},
		javascript = {
			-- prettier
			function()
				return {
					exe = 'prettier',
					args = { '--stdin-filepath', vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), '--single-quote' },
					stdin = true,
				}
			end,
		},
		yaml = {
			-- prettier
			function()
				return {
					exe = 'prettier',
					args = { '--stdin-filepath', vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
					stdin = true,
				}
			end,
		},
		json = {
			-- prettier
			function()
				return {
					exe = 'prettier',
					args = { '--stdin-filepath', vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
					stdin = true,
				}
			end,
		},
		css = {
			-- prettier
			function()
				return {
					exe = 'prettier',
					args = { '--stdin-filepath', vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
					stdin = true,
				}
			end,
		},
		rust = {
			function()
				return {
					exe = 'rustfmt',
					args = { '--emit=stdout' },
					stdin = true,
				}
			end,
		},
		terraform = {
			function()
				return {
					exe = 'terraform',
					args = { 'fmt', '-' },
					stdin = true,
				}
			end,
		},
		lua = {
			function()
				return {
					exe = 'stylua',
					args = { '-', '--config-path', '~/dotfiles/styling/stylua.toml' },
					stdin = true,
				}
			end,
		},
	},
})
