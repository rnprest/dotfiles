local M = {}

local cmp = require 'cmp'
local lspkind = require 'lspkind'

local snip_status_ok, luasnip = pcall(require, 'luasnip')
if not snip_status_ok then
    return
end

----------------------------------------------------------------------
--               enable rafamadriz/friendly-snippets                --
----------------------------------------------------------------------
-- You can also use lazy loading so you only get in memory snippets of languages you use
require('luasnip/loaders/from_vscode').lazy_load() -- You can pass { paths = "./my-snippets/"} as well

local check_backspace = function()
    local col = vim.fn.col '.' - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match '%s'
end

function M.setup()
    cmp.setup {
        ----------------------------------------------------------------------
        --                  add borders to completion menu                  --
        ----------------------------------------------------------------------
        window = {
            completion = { -- rounded border; thin-style scrollbar
                border = 'rounded',
                scrollbar = '║',
            },
            documentation = { -- rounded border; native-style scrollbar
                border = 'rounded',
                scrollbar = '',
            },
        },
        formatting = {
            format = lspkind.cmp_format {
                mode = 'symbol', -- show only symbol annotations
                maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

                -- The function below will be called before any actual modifications from lspkind
                -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                before = function(entry, vim_item)
                    return vim_item
                end,
            },
        },
        snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
                require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            end,
        },
        mapping = {
            ----------------------------------------------------------------------
            --        lol this is the only mapping that matters idk what        --
            --            the rest do. they were included by default            --
            ----------------------------------------------------------------------
            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif check_backspace() then
                    fallback()
                else
                    fallback()
                end
            end, {
                'i',
                's',
            }),
            ----------------------------------------------------------------------
            ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
            ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
            ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
            ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
            ['<C-e>'] = cmp.mapping {
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            },
            ['<CR>'] = cmp.mapping.confirm { select = false }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        },
        sources = cmp.config.sources {
            { name = 'nvim_lsp' },
            { name = 'nvim_lua' },
            { name = 'buffer' },
            { name = 'path' },
            { name = 'cmdline' },
            { name = 'luasnip' }, -- For luasnip users.
        },
    }

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
