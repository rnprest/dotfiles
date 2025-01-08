return {
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        dependencies = { 'williamboman/mason.nvim' },
        config = function()
            require('mason-tool-installer').setup {
                ensure_installed = {
                    'beautysh',
                },
            }
        end,
    },

    {
        'williamboman/mason.nvim',
        dependencies = { 'williamboman/mason-lspconfig.nvim' },
        config = function()
            require('conform').setup {
                formatters_by_ft = {
                    ['sh'] = { 'shfmt' },
                    go = { 'gofumpt' },
                    json = { 'jq' },
                    lua = { 'stylua' },
                    markdown = { 'mdformat' },
                    python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' }, -- Conform will run multiple formatters sequentially
                    rust = { 'rustfmt' },
                    sql = { 'sleek' },
                    terraform = { 'terraform_fmt' },
                    yaml = { 'yamlfmt' },
                    cs = { 'csharpier' },
                },
            }
            -- Setup csharpier (default doesn't work)
            require('conform.formatters.csharpier').command = 'dotnet'
            require('conform.formatters.csharpier').args = function()
                local args = { 'csharpier' }
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
                    if vim.g.disable_autoformat == true then
                        return
                    else
                        local extension = vim.fn.expand '%:e'
                        if extension == 'template' then -- Only manually format cfn templates
                            return
                        end
                        require('conform').format { bufnr = args.buf, timeout_ms = 5000 }
                    end
                end,
            })

            ----------------------------------------------------------------------
            --        Highlight references to the current word you're on        --
            ----------------------------------------------------------------------
            function BufferLspSupportsHighlighting()
                local lsps = vim.lsp.get_active_clients {
                    bufnr = 0,
                }

                for _, client in pairs(lsps or {}) do
                    if client.server_capabilities.documentHighlightProvider then
                        return true
                    end
                end

                return false
            end

            vim.api.nvim_create_augroup('highlight', {})
            vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold' }, {
                group = 'highlight',
                callback = function()
                    if BufferLspSupportsHighlighting() then
                        vim.lsp.buf.document_highlight()
                    end
                end,
            })
            vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorMoved' }, {
                group = 'highlight',
                callback = function()
                    if BufferLspSupportsHighlighting() then
                        vim.lsp.buf.clear_references()
                    end
                end,
            })
            ----------------------------------------------------------------------

            local on_attach = function(client, bufnr)
                require('lsp_signature').on_attach()
                vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
                vim.keymap.set('n', '<leader>dn', '<cmd>Lspsaga diagnostic_jump_next<CR>')
                vim.keymap.set('n', '<leader>dp', '<cmd>Lspsaga diagnostic_jump_prev<CR>')
                vim.keymap.set('n', '<leader>ls', function()
                    -- :LspStop<CR>'
                    vim.cmd 'LspStop'
                    vim.g.disable_autoformat = true
                end)
                vim.keymap.set('n', '<leader>cr', '<cmd>Lspsaga rename<CR>')
                vim.keymap.set('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
                vim.keymap.set('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
                -- vim.keymap.set('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>') -- I never use this...
                vim.keymap.set('n', '<leader>hd', '<cmd>lua vim.lsp.buf.hover()<CR>')

                if client.name ~= 'rust_analyzer' then
                    -- disable LSP formatting conflicts - only use conform.nvim for formatting
                    client.server_capabilities.document_formatting = false
                    client.server_capabilities.document_range_formatting = false
                end

                -- golang fmt imports
                local function go_org_imports(wait_ms)
                    local params = vim.lsp.util.make_range_params()
                    params.context = { only = { 'source.organizeImports' } }
                    local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, wait_ms)
                    for cid, res in pairs(result or {}) do
                        for _, r in pairs(res.result or {}) do
                            if r.edit then
                                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or 'utf-16'
                                vim.lsp.util.apply_workspace_edit(r.edit, enc)
                            end
                        end
                    end
                end

                vim.api.nvim_create_autocmd('BufWritePre', {
                    pattern = { '*.go' },
                    callback = function()
                        go_org_imports()
                    end,
                })
                ---------------------
                -- nvim-navic for statusline code context
                local navic = require 'nvim-navic'
                if client.server_capabilities.documentSymbolProvider then
                    navic.attach(client, bufnr)
                end
            end

            ----------------------------------------------------------------------
            --                              Mason                               --
            ----------------------------------------------------------------------
            require('mason').setup {}
            require('mason-lspconfig').setup {
                ensure_installed = {
                    'bashls',
                    'dockerls',
                    'gopls',
                    'html',
                    'jsonls',
                    'lua_ls',
                    'rust_analyzer',
                    'sqlls',
                    'terraformls',
                    'tflint',
                    'ts_ls',
                    'vimls',
                    'yamlls',
                },
            }

            local installed_servers = require('mason-lspconfig').get_installed_servers()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            local default_opts = {
                on_attach = on_attach,
                capabilities = capabilities,
            }

            for _, server in pairs(installed_servers) do
                if server == 'rust_analyzer' then
                    default_opts.tools = {
                        inlay_hints = {
                            -- prefix for parameter hints
                            -- default: "<-"
                            parameter_hints_prefix = '« ',
                            -- prefix for all the other hints (type, chaining)
                            -- default: "=>"
                            other_hints_prefix = '» ',
                        },
                    }
                elseif server == 'yamlls' then
                    default_opts.settings = {
                        yaml = {
                            customTags = {
                                '!And sequence',
                                '!And',
                                '!Base64',
                                '!Cidr sequence',
                                '!Cidr',
                                '!Condition',
                                '!Equals sequence',
                                '!Equals',
                                '!FindInMap sequence',
                                '!FindInMap',
                                '!GetAZs',
                                '!GetAtt',
                                '!If sequence',
                                '!If',
                                '!ImportValue sequence',
                                '!ImportValue',
                                '!Join sequence',
                                '!Join',
                                '!Not sequence',
                                '!Not',
                                '!Or sequence',
                                '!Or',
                                '!Ref scalar',
                                '!Ref sequence',
                                '!Ref',
                                '!Select sequence',
                                '!Select',
                                '!Split sequence',
                                '!Split',
                                '!Sub sequence',
                                '!Sub',
                                '!fn',
                                '!reference',
                                '!reference sequence',
                            },
                            schemaStore = {
                                url = 'https://www.schemastore.org/api/json/catalog.json',
                                enable = true,
                            },
                            schemaDownload = { enable = true },
                            completion = true,
                            validate = true,
                        },
                    }
                end
                -- default setup for all servers
                require('lspconfig')[server].setup(default_opts)
            end

            require('rust-tools').setup { server = default_opts }
        end,
    },
}
