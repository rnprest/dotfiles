return {
    'onsails/lspkind-nvim', -- Adds symbols to lsp completion menu

    {
        'kyazdani42/nvim-web-devicons',
        config = function()
            require('nvim-web-devicons').setup()
        end,
    },

    -- Only load this plugin in quickfix windows
    {
        'kevinhwang91/nvim-bqf',
        ft = 'qf',
    },

    {
        'rcarriga/nvim-notify',
        config = function()
            require('notify').setup {
                stages = 'fade_in_slide_out',
                timeout = 1000,
                background_colour = '#000000',
                icons = {
                    ERROR = '',
                    WARN = '',
                    INFO = '',
                    DEBUG = '',
                    TRACE = '✎',
                },
            }
            vim.notify = require 'notify'
        end,
    },

    {
        'marko-cerovac/material.nvim',
        dependencies = 'tjdevries/colorbuddy.nvim',
        priority = 1000, -- Load colorscheme FIRST so other plugins can overwrite
        config = function()
            require('material').setup {
                contrast = {
                    floating_windows = true, -- Enable contrast for floating windows
                },
                plugins = { -- Uncomment the plugins that you use to highlight them
                    'gitsigns',
                    'lspsaga',
                    'nvim-cmp',
                    'nvim-web-devicons',
                    'telescope',
                },
                disable = {
                    background = false, -- Prevent the theme from setting the background (NeoVim then uses your terminal background)
                },
            }
            --Lua:
            vim.g.material_style = 'ocean'
            vim.cmd 'colorscheme material'
            -- This highlight needs to load AFTER the colorscheme is set so that it isn't overwritten
            vim.cmd 'highlight CursorLineNr guifg=#fb801a'
            -- Remove the underline from LspReference* (for CursorHold aucmd)
            vim.cmd 'highlight LspReferenceRead gui=NONE guibg=#464B5D'
            vim.cmd 'highlight LspReferenceWrite gui=NONE guibg=#464B5D'
            vim.cmd 'highlight LspReferenceText gui=NONE guibg=#464B5D'
        end,
    },
    -- adds highlighting to markdown files
    {
        'lukas-reineke/headlines.nvim',
        dependencies = 'nvim-treesitter/nvim-treesitter',
        config = true,
    },
}
