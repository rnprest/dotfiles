return {
    {
        'mfussenegger/nvim-lint',
        opts = {},
        config = function()
            require('lint').linters_by_ft = {
                yaml = { 'cfn_lint' },
                json = { 'cfn_lint' },
            }
            -- Customizations
            local cfn_lint = require('lint').linters.cfn_lint
            cfn_lint.args = {
                '-m', -- Always check warnings, even if excluded (pre-commit)
                'W',
                '--format',
                'parseable',
            }
            cfn_lint.ignore_exitcode = true
            -- Autocommands
            local augroup = vim.api.nvim_create_augroup
            local autocmd = vim.api.nvim_create_autocmd
            local linting_group = augroup('Linting', {})
            autocmd('BufWritePost', {
                group = linting_group,
                pattern = '*.template',
                callback = function()
                    require('lint').try_lint()
                end,
            })
        end,
    },
}
