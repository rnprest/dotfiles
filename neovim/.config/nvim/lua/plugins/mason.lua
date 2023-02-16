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
            ----------------------------------------------------------------------
            --                     setup null-ls to format                      --
            ----------------------------------------------------------------------
            local null_ls = require 'null-ls'
            local sources = {
                null_ls.builtins.formatting.black,
                -- Tell prettier to just use whatever the buf says it's ft is
                null_ls.builtins.formatting.prettier.with {
                    extra_args = function(params)
                        return { '--parser', params.ft }
                    end,
                },
                null_ls.builtins.formatting.beautysh,
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.diagnostics.cfn_lint, -- if file contains "Resources" or "AWSTemplateFormatVersion"
            }
            null_ls.setup { sources = sources }

            ----------------------------------------------------------------------
            --          fidget shows status of LSPs while initializing          --
            --                            (eyecandy)                            --
            ----------------------------------------------------------------------
            require('fidget').setup {
                text = {
                    spinner = 'moon',
                },
                align = {
                    bottom = true,
                },
                window = {
                    relative = 'editor',
                },
            }

            -- Format on save
            vim.api.nvim_create_augroup('formatOnSave', {})
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = 'formatOnSave',
                callback = function()
                    vim.lsp.buf.format()
                end,
            })

            ----------------------------------------------------------------------
            --        Highlight references to the current word you're on        --
            ----------------------------------------------------------------------
            function BufferLspSupportsHighlighting()
                local lsps = vim.lsp.get_active_clients()

                for _, client in pairs(lsps or {}) do
                    if client.server_capabilities.documentHighlightProvider then
                        return true
                    end
                end

                return false
            end

            vim.api.nvim_create_augroup('highlight', {})
            vim.api.nvim_create_autocmd('CursorHold', {
                group = 'highlight',
                callback = function()
                    if BufferLspSupportsHighlighting() then
                        vim.lsp.buf.document_highlight()
                    end
                end,
            })
            vim.api.nvim_create_autocmd('CursorMoved', {
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
                vim.keymap.set('n', '<leader>ca', '<cmd>Lspsaga code_action<CR>')
                vim.keymap.set('n', '<leader>dn', '<cmd>Lspsaga diagnostic_jump_next<CR>')
                vim.keymap.set('n', '<leader>dp', '<cmd>Lspsaga diagnostic_jump_prev<CR>')
                vim.keymap.set('n', '<leader>lr', ':LspRestart<CR>')
                vim.keymap.set('n', '<leader>cr', '<cmd>Lspsaga rename<CR>')
                vim.keymap.set('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
                vim.keymap.set('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
                -- vim.keymap.set('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>') -- I never use this...
                vim.keymap.set('n', '<leader>hd', '<cmd>lua vim.lsp.buf.hover()<CR>')

                if client.name ~= 'rust_analyzer' then
                    -- disable LSP formatting conflicts - only use null-ls for formatting
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
                    'pyright',
                    'rust_analyzer',
                    'terraformls',
                    'tsserver',
                    'vimls',
                    'yamlls',
                    'sqls',
                },
            }

            local installed_servers = require('mason-lspconfig').get_installed_servers()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            local default_opts = {
                on_attach = on_attach,
                capabilities = capabilities,
            }

            for _, server in pairs(installed_servers) do
                if server.name == 'rust_analyzer' then
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
                elseif server.name == 'yamlls' then
                    default_opts.settings = {
                        ['yaml'] = {
                            customTags = {
                                '!And sequence',
                                '!And',
                                '!Base64',
                                '!Cidr',
                                '!Condition',
                                '!Equals sequence',
                                '!Equals',
                                '!FindInMap sequence',
                                '!GetAZs',
                                '!GetAtt',
                                '!If sequence',
                                '!If',
                                '!ImportValue',
                                '!Join sequence',
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
                            },
                            schemas = {
                                ['https://raw.githubusercontent.com/awslabs/goformation/v4.18.2/schema/cloudformation.schema.json'] = 'cloudformation/*.template',
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
