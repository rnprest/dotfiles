return {
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup {
                ignore = '^$',
            }
        end,
    },

    {
        's1n7ax/nvim-comment-frame',
        dependencies = {
            { 'nvim-treesitter' },
        },
        config = function()
            require('nvim-comment-frame').setup()
        end,
    },

    {
        'danymat/neogen',
        config = function()
            require('neogen').setup {
                enabled = true,
            }
        end,
        dependencies = 'nvim-treesitter/nvim-treesitter',
    },
}
