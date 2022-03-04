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
    },
}

require('telescope').load_extension 'fzy_native'
require('telescope').load_extension 'file_browser'
require('telescope').load_extension 'git_worktree'

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
local function refactor(prompt_bufnr)
    local content = require('telescope.actions.state').get_selected_entry(prompt_bufnr)
    require('telescope.actions').close(prompt_bufnr)
    require('refactoring').refactor(content.value)
end

M.refactors = function()
    require('telescope.pickers').new({}, {
        prompt_title = 'refactors',
        finder = require('telescope.finders').new_table {
            results = require('refactoring').get_refactors(),
        },
        sorter = require('telescope.config').values.generic_sorter {},
        attach_mappings = function(_, map)
            map('i', '<CR>', refactor)
            map('n', '<CR>', refactor)
            return true
        end,
    }):find()
end

return M
