return {
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        dependencies = { 'williamboman/mason.nvim' },
        config = function()
            require('mason-tool-installer').setup {
                ensure_installed = {
                    -- TODO: add formatters here
                    -- LSP servers
                    'bash-language-server',
                    'gopls',
                    'json-lsp',
                    'lua-language-server',
                    'ruff',
                    'rust-analyzer',
                    'sqlls',
                    'terraform-ls',
                    'vim-language-server',
                    'yaml-language-server',
                },
            }
        end,
    },

    {
        'williamboman/mason.nvim',
        config = function()
            require('conform').setup {
                formatters_by_ft = {
                    ['sh'] = { 'shfmt' },
                    go = { 'gofumpt' },
                    json = { 'jq' },
                    lua = { 'stylua' },
                    markdown = { 'prettier' },
                    python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' }, -- Conform will run multiple formatters sequentially
                    rust = { 'rustfmt' },
                    sql = { 'sleek' },
                    terraform = { 'terraform_fmt' },
                    yaml = { 'yamlfmt' },
                    cs = { 'csharpier' },
                    javascript = { 'prettier' },
                },
            }

            -- Setup csharpier (default doesn't work)
            require('conform.formatters.csharpier').command = 'csharpier'
            require('conform.formatters.csharpier').args = function()
                local args = { 'format' }
                return args
            end

            ----------------------------------------------------------------------
            --          fidget shows status of LSPs while initializing          --
            --                            (eyecandy)                            --
            ----------------------------------------------------------------------
            require('fidget').setup {
                progress = {
                    display = {
                        progress_icon = { pattern = 'moon', period = 1 },
                    },
                },
            }

            -- Format on save
            vim.api.nvim_create_augroup('formatOnSave', {})
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = 'formatOnSave',
                callback = function(args)
                    if vim.g.disable_autoformat or vim.b[args.buf].disable_autoformat then
                        return
                    end
                    local extension = vim.fn.expand '%:e'
                    if extension == 'template' then -- Only manually format cfn templates
                        return
                    end
                    require('conform').format { bufnr = args.buf, timeout_ms = 5000 }
                end,
            })

            ----------------------------------------------------------------------
            --                              Mason                               --
            ----------------------------------------------------------------------
            require('mason').setup {}
        end,
    },
}
