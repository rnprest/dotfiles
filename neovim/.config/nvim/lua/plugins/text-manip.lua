return {
    'wellle/targets.vim', -- Better text object movement
    'tpope/vim-repeat', -- Repeat plugins with '.',
    'tpope/vim-abolish', -- Coercion between snake_case, camelCase, etc. (crs & crc)

    { -- aligning text (<count>gl(L)<motion><char>)
        'tommcdo/vim-lion',
        config = function()
            vim.cmd 'let b:lion_squeeze_spaces = 1'
        end,
    },

    {
        'kylechui/nvim-surround',
        config = function()
            require('nvim-surround').setup {
                -- Configuration here, or leave empty to use defaults
            }
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
            {
                '<C-a>',
                function()
                    require('dial.map').inc_visual()
                end,
                mode = 'v',
            },
            {
                '<C-x>',
                function()
                    require('dial.map').dec_visual()
                end,
                mode = 'v',
            },
            {
                'g<C-a>',
                function()
                    require('dial.map').inc_gvisual()
                end,
                mode = 'v',
            },
            {
                'g<C-x>',
                function()
                    require('dial.map').dec_gvisual()
                end,
                mode = 'v',
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