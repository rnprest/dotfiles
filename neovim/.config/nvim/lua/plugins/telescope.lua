local M = {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/popup.nvim',
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-fzy-native.nvim',
        'nvim-telescope/telescope-ui-select.nvim',
        'nvim-telescope/telescope-file-browser.nvim',
        'nvim-telescope/telescope-live-grep-args.nvim',
        'ThePrimeagen/git-worktree.nvim',
        'LinArcX/telescope-env.nvim',
    },
    keys = {
        {
            '<leader>dot',
            function()
                return require('plugins.telescope').search_dotfiles()
            end,
            silent = true,
            noremap = true,
        },
        {
            '<leader>gb',
            function()
                return require('plugins.telescope').git_branches()
            end,
            silent = true,
            noremap = true,
        },
        {
            '<leader>pb',
            function()
                return require('telescope.builtin').buffers()
            end,
            silent = true,
            noremap = true,
        },
        {
            '<leader>pf',
            function()
                return require('telescope.builtin').git_files()
            end,
            silent = true,
            noremap = true,
        },
        {
            '<leader><leader>f',
            function()
                return require('telescope.builtin').find_files()
            end,
            silent = true,
            noremap = true,
        },
        {
            '<leader>pw',
            function()
                return require('telescope').extensions.live_grep_args.live_grep_raw {
                    default_text = vim.fn.expand '<cword>',
                }
            end,
            silent = true,
            noremap = true,
        },
        {
            '<leader>ps',
            function()
                return require('telescope').extensions.live_grep_args.live_grep_args()
            end,
            silent = true,
            noremap = true,
        },
        {
            '<leader>th',
            function()
                return require('telescope.builtin').help_tags { layout_strategy = 'vertical' }
            end,
            silent = true,
            noremap = true,
        },
        {
            '<leader>t:',
            function()
                return require('telescope.builtin').command_history()
            end,
            silent = true,
            noremap = true,
        },
        {
            '<leader>dqf',
            function()
                return require('telescope.builtin').diagnostics()
            end,
            silent = true,
            noremap = true,
        },
    },
    config = function()
        local actions = require 'telescope.actions'
        local lga_actions = require 'telescope-live-grep-args.actions'

        require('telescope').setup {
            defaults = {
                file_sorter = require('telescope.sorters').get_fzy_sorter,
                prompt_prefix = ' >',
                color_devicons = true,

                file_previewer = require('telescope.previewers').vim_buffer_cat.new,
                grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
                qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

                mappings = {
                    i = {
                        ['<C-x>'] = false,
                        ['<C-q>'] = actions.send_to_qflist,
                    },
                },
            },
            extensions = {
                fzy_native = {
                    override_generic_sorter = false,
                    override_file_sorter = true,
                },
                ['ui-select'] = {
                    require('telescope.themes').get_dropdown {
                        -- even more opts
                    },
                },
                live_grep_args = {
                    auto_quoting = true, -- enable/disable auto-quoting
                    mappings = { -- extend mappings
                        i = {
                            -- quote prompt and add a glob for a filetype
                            ['<C-k>'] = lga_actions.quote_prompt { postfix = ' -g "*.' },
                        },
                    },
                },
            },
        }

        require('telescope').load_extension 'fzy_native'
        require('telescope').load_extension 'file_browser'
        require('telescope').load_extension 'ui-select'
        require('telescope').load_extension 'git_worktree'
        require('telescope').load_extension 'env'
        require('telescope').load_extension 'refactoring'

        -- remap to open the Telescope refactoring menu in visual mode
        vim.api.nvim_set_keymap(
            'v',
            '<leader><leader>r',
            "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
            { noremap = true }
        )
    end,
}

M.search_dotfiles = function()
    require('telescope.builtin').git_files {
        prompt_title = '< dotfiles >',
        cwd = '$HOME/dotfiles/',
    }
end

M.git_branches = function()
    require('telescope.builtin').git_branches {
        attach_mappings = function(_, map)
            map('i', '<c-d>', require('telescope.actions').git_delete_branch)
            map('n', '<c-d>', require('telescope.actions').git_delete_branch)
            return true
        end,
    }
end

return M
