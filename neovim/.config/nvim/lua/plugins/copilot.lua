return {
    'github/copilot.vim',
    config = function()
        vim.keymap.set('i', '<leader>co', 'copilot#Accept("")', {
            expr = true,
            replace_keycodes = false,
        })
        vim.g.copilot_no_tab_map = true
    end,
}
