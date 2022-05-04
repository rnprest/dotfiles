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

    ----------------------------------------------------------------------
    --               Integrating nvim-lsp-installer with                --
    --                         rust-tools.nvim                          --
    ----------------------------------------------------------------------
    if server.name == 'rust_analyzer' then
        opts = {
            on_attach = on_attach,
            capabilities = capabilities,
            tools = {
                inlay_hints = {
                    -- prefix for parameter hints
                    -- default: "<-"
                    parameter_hints_prefix = '« ',
                    -- prefix for all the other hints (type, chaining)
                    -- default: "=>"
                    other_hints_prefix = '» ',
                },
            },
        }
        -- Initialize the LSP via rust-tools instead
        require('rust-tools').setup {
            -- The "server" property provided in rust-tools setup function are the
            -- settings rust-tools will provide to lspconfig during init.            --
            -- We merge the necessary settings from nvim-lsp-installer (server:get_default_options())
            -- with the user's own settings (opts).
            server = vim.tbl_deep_extend('force', server:get_default_options(), opts),
        }
        server:attach_buffers()
        -- Only if standalone support is needed
        require('rust-tools').start_standalone_if_required()
    else
        server:setup(opts)
    end
end)
