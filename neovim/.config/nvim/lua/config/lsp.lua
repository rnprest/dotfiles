local M = {}

local function on_attach(client, bufnr)
    require('lsp_signature').on_attach()

    -- Keymaps
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
    vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev)
    vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename)
    vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition)
    vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation)
    vim.keymap.set('n', '<leader>hd', vim.lsp.buf.hover)

    -- nvim-navic for statusline code context
    local navic = require 'nvim-navic'
    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end
end

-- Configure global LSP settings
vim.lsp.config('*', {
    root_markers = { '.git' },
    on_attach = on_attach,
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

-- Configure individual language servers
function M.setup()
    -- Bash LSP
    vim.lsp.config.bashls = {
        cmd = { 'bash-language-server', 'start' },
        filetypes = { 'bash', 'sh' },
    }

    -- Go LSP
    vim.lsp.config.gopls = {
        cmd = { 'gopls' },
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
    }

    -- JSON LSP
    vim.lsp.config.jsonls = {
        cmd = { 'vscode-json-language-server', '--stdio' },
        filetypes = { 'json', 'jsonc' },
    }

    -- Lua LSP
    vim.lsp.config.lua_ls = {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = {
            '.emmyrc.json',
            '.luarc.json',
            '.luarc.jsonc',
            '.luacheckrc',
            '.stylua.toml',
            'stylua.toml',
            'selene.toml',
            'selene.yml',
            '.git',
        },
        settings = {
            Lua = {
                codeLens = { enable = true },
                hint = { enable = true, semicolon = 'Disable' },
                diagnostics = {
                    globals = { 'vim' },
                },
            },
        },
    }

    -- Python LSP (Ruff)
    vim.lsp.config.ruff = {
        cmd = { 'ruff', 'server' },
        filetypes = { 'python' },
        root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
    }

    -- Python type-checker (ty)
    vim.lsp.config.ty = {
        cmd = { 'ty', 'server' },
        filetypes = { 'python' },
        root_markers = { 'ty.toml', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
    }

    -- SQL LSP
    vim.lsp.config.sqlls = {
        cmd = { 'sql-language-server', 'up', '--method', 'stdio' },
        filetypes = { 'sql', 'mysql' },
        root_markers = { '.sqllsrc.json' },
    }

    -- Terraform LSP
    vim.lsp.config.terraformls = {
        cmd = { 'terraform-ls', 'serve' },
        filetypes = { 'terraform', 'terraform-vars', 'tf' },
        root_markers = { '.terraform', '.git' },
    }

    -- Vim LSP
    vim.lsp.config.vimls = {
        cmd = { 'vim-language-server', '--stdio' },
        filetypes = { 'vim' },
        root_markers = { '.git' },
        init_options = {
            isNeovim = true,
            iskeyword = '@,48-57,_,192-255,-#',
            vimruntime = '',
            runtimepath = '',
            diagnostic = { enable = true },
            indexes = {
                runtimepath = true,
                gap = 100,
                count = 3,
                projectRootPatterns = { 'runtime', 'nvim', '.git', 'autoload', 'plugin' },
            },
            suggest = { fromVimruntime = true, fromRuntimepath = true },
        },
    }

    -- YAML LSP
    vim.lsp.config.yamlls = {
        cmd = { 'yaml-language-server', '--stdio' },
        filetypes = { 'yaml', 'yml', 'yaml.docker-compose', 'yaml.gitlab', 'yaml.helm-values' },
        root_markers = { '.git' },
        settings = {
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
        },
    }

    -- Enable all configured LSP servers
    vim.lsp.enable {
        'bashls',
        'gopls',
        'jsonls',
        'lua_ls',
        'ruff',
        'ty',
        -- 'rust_analyzer', -- already configured via 'mrcjkb/rustaceanvim'
        'sqlls',
        'terraformls',
        'vimls',
        'yamlls',
    }
end

-- Document highlighting setup
local function setup_document_highlighting()
    local function buffer_supports_highlighting()
        local clients = vim.lsp.get_clients { bufnr = 0 }
        for _, client in pairs(clients) do
            if client.server_capabilities.documentHighlightProvider then
                return true
            end
        end
        return false
    end

    vim.api.nvim_create_augroup('LspDocumentHighlight', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold' }, {
        group = 'LspDocumentHighlight',
        callback = function()
            if buffer_supports_highlighting() then
                vim.lsp.buf.document_highlight()
            end
        end,
    })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorMoved' }, {
        group = 'LspDocumentHighlight',
        callback = function()
            if buffer_supports_highlighting() then
                vim.lsp.buf.clear_references()
            end
        end,
    })
end

-- Initialize LSP
function M.init()
    M.setup()
    setup_document_highlighting()
end

return M
