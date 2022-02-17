local lsp_installer = require('nvim-lsp-installer')
local lsp_status = require('lsp-status')
lsp_status.register_progress()

local on_attach = function(client, bufnr)
	require('lsp_signature').on_attach()
	require('nest').applyKeymaps({
		{
			mode = 'n',
			{
				{ '<leader>ca', '<cmd>Lspsaga code_action<CR>' },
				{ '<leader>dn', '<cmd>Lspsaga diagnostic_jump_next<CR>' },
				{ '<leader>dp', '<cmd>Lspsaga diagnostic_jump_prev<CR>' },
				{ '<leader>lh', '<cmd>Lspsaga hover_doc<CR>' },
				{ '<leader>lr', ':LspRestart<CR>' },
				{ '<leader>ra', '<cmd>Lspsaga rename<CR>' },
				{ '<leader>bgd', '<cmd>lua vim.lsp.buf.definition()<CR>' },
				{ '<leader>bgi', '<cmd>lua vim.lsp.buf.implementation()<CR>' },
				{ '<leader>bgr', '<cmd>lua vim.lsp.buf.references()<CR>' },
			},
		},
	})

	lsp_status.on_attach(client, bufnr)
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
