local lsp_installer = require 'nvim-lsp-installer'

----------------------------------------------------------------------
--                     setup null-ls to format                      --
----------------------------------------------------------------------
local null_ls = require 'null-ls'
local sources = {
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.rustfmt,
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
            },
        },
    }

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        vim.cmd [[
		    augroup lsp_document_highlight
		    	autocmd! * <buffer>
		    	autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
		    	autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
			augroup END
		]]
    end

    -- disable LSP formatting conflicts - only use null-ls for formatting
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
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
