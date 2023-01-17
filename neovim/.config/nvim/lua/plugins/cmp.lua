return {
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'saadparwaiz1/cmp_luasnip',

    {
        'hrsh7th/cmp-nvim-lsp',
        dependencies = { 'williamboman/mason.nvim' },
    },

    {
        'hrsh7th/nvim-cmp',
        event = 'BufEnter',
        config = function()
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

            cmp.setup {
                -- Don't show completion menu when on an empty line
                enabled = function()
                    local curline = vim.api.nvim_get_current_line()
                    local line_is_just_whitespace = vim.fn.empty(vim.fn.matchstr(curline, [[^\s*$]]))

                    if line_is_just_whitespace == 0 or curline == '' then
                        return false
                    else
                        return true
                    end
                end,
                ----------------------------------------------------------------------
                --                  add borders to completion menu                  --
                ----------------------------------------------------------------------
                window = {
                    completion = {
                        border = 'rounded',
                        -- scrollbar = '║',
                    },
                    documentation = {
                        border = 'rounded',
                        -- scrollbar = '',
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
                    { name = 'luasnip' }, -- For luasnip users.
                },
            }
        end,
    },
}
