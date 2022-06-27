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
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.terraform_fmt,
    null_ls.builtins.diagnostics.write_good,
    null_ls.builtins.diagnostics.cfn_lint, -- if file contains "Resources" or "AWSTemplateFormatVersion"
}
null_ls.setup { sources = sources }

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
local lsp_augroup = vim.api.nvim_create_augroup('LspFormatting', {})
local on_attach = function(client, bufnr)
    require('lsp_signature').on_attach()
    vim.keymap.set('n', '<leader>ca', '<cmd>Lspsaga code_action<CR>')
    vim.keymap.set('n', '<leader>dn', '<cmd>Lspsaga diagnostic_jump_next<CR>')
    vim.keymap.set('n', '<leader>dp', '<cmd>Lspsaga diagnostic_jump_prev<CR>')
    vim.keymap.set('n', '<leader>lr', ':LspRestart<CR>')
    vim.keymap.set('n', '<leader>cr', '<cmd>Lspsaga rename<CR>')
    vim.keymap.set('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
    vim.keymap.set('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
    vim.keymap.set('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>')
    vim.keymap.set('n', '<leader>hd', '<cmd>lua vim.lsp.buf.hover()<CR>')

    -- Set autocommands conditional on server_capabilities
    if client.supports_method 'textDocument/formatting'
        and client.supports_method 'textDocument/signatureHelp'
        and client.supports_method 'textDocument/documentHighlight'
    then
        vim.api.nvim_clear_autocmds { group = lsp_augroup, buffer = bufnr }
        vim.api.nvim_create_autocmd('CursorHold', {
            group = lsp_augroup,
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.document_highlight()
            end,
        })
        vim.api.nvim_create_autocmd('CursorMoved', {
            group = lsp_augroup,
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.clear_references()
            end,
        })
        -- Format on save
        vim.api.nvim_create_autocmd('BufWritePre', {
            group = lsp_augroup,
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format { bufnr = bufnr }
            end,
        })

        -- local lsp = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = true })
        vim.api.nvim_create_autocmd('BufWritePre', { buffer = 0, command = 'lua vim.lsp.buf.format()', group = lsp })
    end

    if client.name ~= 'rust_analyzer' then
        -- disable LSP formatting conflicts - only use null-ls for formatting
        client.server_capabilities.document_formatting = false
        client.server_capabilities.document_range_formatting = false
    end
end

----------------------------------------------------------------------
--                          lsp-installer                           --
----------------------------------------------------------------------
require('nvim-lsp-installer').setup {}
local installed_servers = require('nvim-lsp-installer').get_installed_servers()
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

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
                    '!Base64',
                    '!Cidr',
                    '!Condition',
                    '!Equals sequence',
                    '!FindInMap sequence',
                    '!GetAZs',
                    '!GetAtt',
                    '!If sequence',
                    '!ImportValue',
                    '!Join sequence',
                    '!Not sequence',
                    '!Or sequence',
                    '!Ref',
                    '!Select sequence',
                    '!Split sequence',
                    '!Sub sequence',
                    '!Sub',
                },
            },
        }
    end
    -- default setup for all servers
    require('lspconfig')[server.name].setup(default_opts)
end

-- TODO - this isn't showing my inlay hints :(
require('rust-tools').setup { server = default_opts }
