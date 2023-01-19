return {
    {
        'tpope/vim-fugitive',
        keys = {
            { '<leader>gl', ':Git log --oneline<CR>', silent = true, noremap = true },
            { '<leader>gr', ':Git rebase -i <cword><CR>', silent = true, noremap = true },
            { '<leader>g-', ':Git stash<CR>', silent = true, noremap = true },
            { '<leader>g+', ':Git stash pop<CR>', silent = true, noremap = true },
            { '<leader>gp', ':Git push<CR>', silent = true, noremap = true },
            { '<leader>gP', ':Git push -f<CR>', silent = true, noremap = true },
            { '<leader>gs', ':G<CR>', silent = true, noremap = true },
            { '<leader>gu', ':diffget //2<CR>', silent = true, noremap = true }, -- :Gdiff, pull in target (current branch) changes from left
            { '<leader>gh', ':diffget //3<CR>', silent = true, noremap = true }, -- :Gdiff, pull in merge changes from right
            -- other modes
            { '<leader>ol', ':GBrowse<CR>', silent = true, noremap = true, mode = 'x' }, -- Open line(s)
        },
    },

    {
        'lewis6991/gitsigns.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        config = function()
            require('gitsigns').setup()
        end,
    },

    {
        'f-person/git-blame.nvim',
        config = function()
            vim.g.gitblame_set_extmark_options = {
                hl_mode = 'combine',
            }
            vim.g.gitblame_date_format = '%r'
        end,
    },

    {
        'ruifm/gitlinker.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
        config = function()
            require 'config.gitlinker'
        end,
        keys = {
            '<leader>of',
        },
        cond = function()
            local fn = vim.fn
            local gitlinker_path = '~/dotfiles/neovim/.config/nvim/lua/config/gitlinker.lua'
            if fn.empty(fn.glob(gitlinker_path)) > 0 then
                return false
            end
            return true
        end,
    },
}
