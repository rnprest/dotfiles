local lsp_installer = require 'nvim-lsp-installer'

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

local on_attach = function(client, bufnr)
    require('lsp_signature').on_attach()
    require('nest').applyKeymaps {
        {
            mode = 'n',
            {
                { '<leader>ca', '<cmd>Lspsaga code_action<CR>' },
                { '<leader>dn', '<cmd>Lspsaga diagnostic_jump_next<CR>' },
                { '<leader>dp', '<cmd>Lspsaga diagnostic_jump_prev<CR>' },
                { '<leader>lr', ':LspRestart<CR>' },
                { '<leader>cr', '<cmd>Lspsaga rename<CR>' },
                { '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>' },
                { '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>' },
                { '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>' },
                { '<leader>hd', '<cmd>lua vim.lsp.buf.hover()<CR>' },
            },
        },
    }

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        local lsp = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = true })
        vim.api.nvim_create_autocmd(
            'CursorHold',
            { buffer = 0, command = 'lua vim.lsp.buf.document_highlight()', group = lsp }
        )
        vim.api.nvim_create_autocmd(
            'CursorMoved',
            { buffer = 0, command = 'lua vim.lsp.buf.clear_references()', group = lsp }
        )
        -- Format on save
        vim.api.nvim_create_autocmd(
            'BufWritePre',
            { buffer = 0, command = 'lua vim.lsp.buf.formatting_sync()', group = lsp }
        )
    end

    if client.name ~= 'rust_analyzer' then
        -- disable LSP formatting conflicts - only use null-ls for formatting
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
    end
end

lsp_installer.on_server_ready(function(server)
    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

    local opts = {
        on_attach = on_attach,
        capabilities = capabilities,
    }

    -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
    server:setup(opts)
    -- I don't think we need this
    -- vim.cmd([[ do User LspAttachBuffers ]])
end)
