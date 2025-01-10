return {
    {
        'tpope/vim-fugitive',
        config = function()
            vim.cmd 'command Conflict Gvdiffsplit!'
        end,
        cmd = 'Conflict',
        keys = {
            { '<leader>gl', ':Git log --oneline<CR>', silent = true, noremap = true },
            { '<leader>gr', ':Git rebase -i <cword><CR>', silent = true, noremap = true },
            { '<leader>g-', ':Git stash<CR>', silent = true, noremap = true },
            { '<leader>g+', ':Git stash pop<CR>', silent = true, noremap = true },
            { '<leader>gp', ':Git push<CR>', silent = true, noremap = true },
            { '<leader>gP', ':Git push -f<CR>', silent = true, noremap = true },
            {
                '<leader>gfp',
                ':!git push -u origin $(git symbolic-ref --short HEAD)<CR>',
                silent = true,
                noremap = true,
            },
            { '<leader>mr', ':!git mr<CR>', silent = true, noremap = true },
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
        'aaronhallaert/advanced-git-search.nvim',
        config = function()
            require('telescope').load_extension 'advanced_git_search'
            vim.api.nvim_create_user_command(
                'DiffCommitLine',
                "lua require('telescope').extensions.advanced_git_search.diff_commit_line()",
                { range = true }
            )
        end,

        keys = {
            {
                '<leader>dcf',
                [[:lua require('telescope').extensions.advanced_git_search.diff_commit_file()<CR>]],
                silent = true,
                noremap = true,
            },
            {
                '<leader>dcl',
                ':DiffCommitLine<CR>',
                mode = 'v',
                silent = true,
                noremap = true,
            },
        },
        dependencies = {
            'nvim-telescope/telescope.nvim',
            -- to show diff splits and open commits in browser
            'tpope/vim-fugitive',
        },
    },
    {
        'linrongbin16/gitlinker.nvim',
        cmd = 'GitLink',
        opts = {},
        config = function()
            local GITLINKER_HOST = vim.fn.getenv 'GITLINKER_HOST'
            local GITLINKER_URL = vim.fn.getenv 'GITLINKER_URL'
            require('gitlinker').setup {
                router = {
                    browse = {
                        [GITLINKER_HOST] = GITLINKER_URL
                            .. '{_A.ORG}/'
                            .. '{_A.REPO}/blob/'
                            .. '{_A.CURRENT_BRANCH}/'
                            .. '{_A.FILE}'
                            .. '#L{_A.LSTART}'
                            .. "{(_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or '')}",
                    },
                    file_only = {
                        [GITLINKER_HOST] = GITLINKER_URL
                            .. '{_A.ORG}/'
                            .. '{_A.REPO}/blob/'
                            .. '{_A.CURRENT_BRANCH}/'
                            .. '{_A.FILE}',
                    },
                },
            }
        end,
        keys = {
            {
                '<leader>of',
                '<cmd>GitLink!<cr>',
                mode = { 'v' },
                desc = 'Open file in browser',
            },
            {
                '<leader>of',
                '<cmd>GitLink! file_only<cr>',
                mode = { 'n' },
                desc = 'Open file in browser',
            },
        },
    },
}
