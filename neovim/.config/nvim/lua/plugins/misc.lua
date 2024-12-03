return {
    -- Documentation
    {
        'ThePrimeagen/harpoon',
        dependencies = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
        keys = {
            {
                '<leader>hh',
                function()
                    return require('harpoon.mark').add_file()
                end,
                silent = true,
                noremap = true,
            },
            {
                '<leader>hm',
                function()
                    return require('harpoon.ui').toggle_quick_menu()
                end,
                silent = true,
                noremap = true,
            },
            {
                '<C-h>',
                function()
                    return require('harpoon.ui').nav_file(1)
                end,
                silent = true,
                noremap = true,
            },
            {
                '<C-t>',
                function()
                    return require('harpoon.ui').nav_file(2)
                end,
                silent = true,
                noremap = true,
            },
            {
                '<C-n>',
                function()
                    return require('harpoon.ui').nav_file(3)
                end,
                silent = true,
                noremap = true,
            },
            {
                '<C-s>',
                function()
                    return require('harpoon.ui').nav_file(4)
                end,
                silent = true,
                noremap = true,
            },
        },
    },

    -- Screenshots
    {
        'michaelrommel/nvim-silicon',
        lazy = true,
        cmd = 'Silicon',
        main = 'nvim-silicon',
        opts = {
            line_offset = 1,
            theme = 'material',
            font = 'Iosevka Nerd Font Mono=20',
            background = '#FFFFFF00',
            no_line_number = false,
            shadow_blur_radius = 7,
            gobble = true,
            pad_horiz = 20,
            pad_vert = 20,
            no_window_controls = true,
        },
        keys = {
            {
                '<leader>ss',
                function()
                    require('nvim-silicon').clip()
                end,
                silent = true,
                noremap = true,
                mode = 'v',
            },
        },
    },

    {
        'folke/snacks.nvim',
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            terminal = { enabled = true },
        },
        keys = {
            {
                '<c-g>',
                function()
                    Snacks.terminal()
                end,
                desc = 'Toggle Terminal',
                mode = { 'n', 'i', 't' },
            },
        },
    },

    {
        'rnprest/snip-lookup.nvim',
        dependencies = 'nvim-telescope/telescope.nvim',
        build = './install.sh',
        config = function()
            require('snip-lookup').setup {
                config_file = '~/snippets/snippets.yaml',
            }
        end,
        keys = {
            '<leader>sl',
            '<leader>esl',
        },
    },

    'tpope/vim-dadbod',

    {
        'nvim-pack/nvim-spectre',
        dependencies = 'nvim-lua/plenary.nvim',
        keys = {
            { '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', silent = true, noremap = true, mode = 'n' },
        },
        config = function()
            require('spectre').setup {
                replace_engine = {
                    ['sed'] = {
                        cmd = 'sed',
                        args = {
                            '-i',
                            '',
                            '-E',
                        },
                    },
                },
            }
        end,
    },

    {
        'echasnovski/mini.nvim',
        version = false,
        config = function()
            require('mini.surround').setup {
                mappings = {
                    replace = 'sc',
                },
            }
            require('mini.operators').setup()
            require('mini.files').setup {
                mappings = {
                    synchronize = '<CR>',
                },
            }
            vim.cmd 'command E lua MiniFiles.open()'

            ----------------------------------------------------------------------
            --                        Highlight Patterns                        --
            ----------------------------------------------------------------------
            local hipatterns = require 'mini.hipatterns'
            local words = { red = '#ff0000', green = '#00ff00', blue = '#0000ff' }
            local word_color_group = function(_, match)
                local hex = words[match]
                if hex == nil then
                    return nil
                end
                return hipatterns.compute_hex_color_group(hex, 'bg')
            end
            hipatterns.setup {
                highlighters = {
                    fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
                    hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
                    todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
                    note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
                    info = { pattern = '%f[%w]()INFO()%f[%W]', group = 'MiniHipatternsNote' },
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                    word_color = { pattern = '%S+', group = word_color_group },
                    trailing_whitespace = { pattern = '%f[%s]%s*$', group = 'Error' },
                },
            }
            ----------------------------------------------------------------------
            require('mini.ai').setup {
                search_method = 'cover_or_nearest',
            }
        end,
    },
}
