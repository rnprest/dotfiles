return {
    'wellle/targets.vim', -- Better text object movement
    'tpope/vim-repeat', -- Repeat plugins with '.',
    'tpope/vim-abolish',

    {
        'johmsalas/text-case.nvim',
        config = function()
            require('textcase').setup()
        end,
        keys = {
            {
                'crc',
                [[ :lua require('textcase').current_word('to_camel_case')<CR> ]],
                silent = true,
                noremap = true,
                mode = 'n',
            },
            {
                'crs',
                [[ :lua require('textcase').current_word('to_snake_case')<CR> ]],
                silent = true,
                noremap = true,
                mode = 'n',
            },
            {
                'crp',
                [[ :lua require('textcase').current_word('to_pascal_case')<CR> ]],
                silent = true,
                noremap = true,
                mode = 'n',
            },
            {
                'cr-',
                [[ :lua require('textcase').current_word('to_dash_case')<CR> ]],
                silent = true,
                noremap = true,
                mode = 'n',
            },
        },
    },

    { -- aligning text (<count>gl(L)<motion><char>)
        'tommcdo/vim-lion',
        config = function()
            vim.cmd 'let b:lion_squeeze_spaces = 1'
        end,
    },

    {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup()
        end,
    },

    {
        'ThePrimeagen/refactoring.nvim',
        dependencies = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
        config = function()
            require('refactoring').setup {}
        end,
        keys = {
            {
                '<leader>da',
                function()
                    return require('refactoring').debug.printf { below = false }
                end,
                silent = true,
                noremap = true,
            },
            {
                '<leader>db',
                function()
                    return require('refactoring').debug.printf { below = true }
                end,
                silent = true,
                noremap = true,
            },
        },
    },

    { -- Better increment/decrement
        'monaqa/dial.nvim',
        keys = {
            {
                '<C-a>',
                function()
                    return require('dial.map').inc_normal()
                end,
                expr = true,
                desc = 'Increment',
            },
            {
                '<C-x>',
                function()
                    return require('dial.map').dec_normal()
                end,
                expr = true,
                desc = 'Decrement',
            },
        },
        config = function()
            local augend = require 'dial.augend'
            require('dial.config').augends:register_group {
                default = {
                    augend.integer.alias.decimal,
                    augend.integer.alias.hex,
                    augend.date.alias['%Y/%m/%d'],
                    augend.constant.new {
                        elements = { 'and', 'or' },
                        word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
                        cyclic = true, -- "or" is incremented into "and".
                    },
                    augend.constant.new {
                        elements = { '&&', '||' },
                        word = false,
                        cyclic = true,
                    },
                    augend.constant.new {
                        elements = { 'true', 'false' },
                        word = true,
                        cyclic = true,
                    },
                    augend.constant.new {
                        elements = { 'True', 'False' },
                        word = true,
                        cyclic = true,
                    },
                },
            }
        end,
    },
}
