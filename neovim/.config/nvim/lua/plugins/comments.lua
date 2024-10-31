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
        keys = {
            '<leader>cf',
            '<leader>cm',
        },
    },
}
