return {
    'gennaro-tedesco/nvim-peekup', -- "" to view and save registers
    -- Documentation
    'nanotee/luv-vimdocs',
    'milisims/nvim-luaref',

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
            {
                '<C-g>',
                function()
                    return require('harpoon.term').gotoTerminal(1)
                end,
                silent = true,
                noremap = true,
            },
            {
                '<C-c>',
                function()
                    return require('harpoon.term').gotoTerminal(2)
                end,
                silent = true,
                noremap = true,
            },
        },
    },

    -- TODO: Try remaping to this instead of lsp codeaction (remap to :lua CodeActionMenu<CR>)
    { -- Code action menu with diffs
        'weilbith/nvim-code-action-menu',
        cmd = 'CodeActionMenu',
    },

    -- Call :FeMaco with cursor on a markdown code-block to edit with proper lsp
    {
        'AckslD/nvim-FeMaco.lua',
        config = function()
            require('femaco').setup()
        end,
    },

    -- call :S3Edit to edit an s3 file, and re-upload it on bufwrite
    {
        'kiran94/s3edit.nvim',
        config = function()
            require('s3edit').setup()
        end,
    },

    -- just absolutely glorious filesystem editing
    {
        'elihunter173/dirbuf.nvim',
        config = function()
            require('dirbuf').setup {
                sort_order = 'directories_first',
            }
        end,
    },

    -- Screenshots
    {
        'krivahtoo/silicon.nvim',
        build = './install.sh',
        config = function()
            require('silicon').setup {
                font = 'Iosevka Nerd Font Mono=20',
                background = '#ffffff',
                line_number = true,
                shadow = {
                    blur_radius = 7.0,
                },
                pad_horiz = 20,
                pad_vert = 20,
                window_controls = false,
            }
            vim.keymap.set('v', '<leader>ss', [[:Silicon<CR>]])
        end,
    },

    {
        'rnprest/merge-request.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
        config = function()
            require('merge-request').setup()
        end,
    },

    {
        'rnprest/snip-lookup.nvim',
        dependencies = { 'nvim-telescope/telescope.nvim' },
        build = './install.sh',
        config = function()
            require('snip-lookup').setup {
                config_file = '~/snippets/snippets.yaml',
            }
        end,
    },
}