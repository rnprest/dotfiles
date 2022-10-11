require('telescope').load_extension 'fzy_native'
require('telescope').load_extension 'file_browser'
require('telescope').load_extension 'ui-select'
require('telescope').load_extension 'git_worktree'
require('telescope').load_extension 'env'

local actions = require 'telescope.actions'
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
    },
}

local M = {}
M.search_dotfiles = function()
    require('telescope.builtin').git_files {
        prompt_title = '< dotfiles >',
        cwd = '$HOME/dotfiles/',
    }
end

M.git_branches = function()
    require('telescope.builtin').git_branches {
        attach_mappings = function(_, map)
            map('i', '<c-d>', actions.git_delete_branch)
            map('n', '<c-d>', actions.git_delete_branch)
            return true
        end,
    }
end

--------------------------------------------------------------------------------
-- Refactoring
--------------------------------------------------------------------------------
-- load refactoring Telescope extension
require('telescope').load_extension 'refactoring'

-- remap to open the Telescope refactoring menu in visual mode
vim.api.nvim_set_keymap(
    'v',
    '<leader>rr',
    "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
    { noremap = true }
)

return M
