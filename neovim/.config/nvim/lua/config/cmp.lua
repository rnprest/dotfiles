local M = {}

local cmp = require('cmp')
local lspkind = require('lspkind')

function M.setup()
	cmp.setup({
		formatting = {
			format = lspkind.cmp_format({
				mode = 'symbol', -- show only symbol annotations
				maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

				-- The function below will be called before any actual modifications from lspkind
				-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
				before = function(entry, vim_item)
					return vim_item
				end,
			}),
		},
		snippet = {
			-- REQUIRED - you must specify a snippet engine
			expand = function(args)
				vim.fn['vsnip#anonymous'](args.body) -- For `vsnip` users.
			end,
		},
		mapping = {
			----------------------------------------------------------------------
			--        lol this is the only mapping that matters idk what        --
			--            the rest do. they were included by default            --
			----------------------------------------------------------------------
			['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
			----------------------------------------------------------------------
			['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
			['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
			['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
			['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
			['<C-e>'] = cmp.mapping({
				i = cmp.mapping.abort(),
				c = cmp.mapping.close(),
			}),
			['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		},
		sources = cmp.config.sources({
			{ name = 'nvim_lsp' },
			{ name = 'nvim_lua' },
			{ name = 'buffer' },
			{ name = 'path' },
			{ name = 'cmdline' },
		}),
	})

	----------------------------------------------------------------------
	--                           cmp-cmdline                            --
	----------------------------------------------------------------------
	-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline('/', {
		sources = {
			{ name = 'buffer' },
		},
	})

	-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline(':', {
		sources = cmp.config.sources({
			{ name = 'path' },
		}, {
			{ name = 'cmdline' },
		}),
	})
end

return M
