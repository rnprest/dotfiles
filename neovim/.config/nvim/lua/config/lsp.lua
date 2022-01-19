-------------------------------------------------------------------------------
-- LSP-STATUS
-------------------------------------------------------------------------------
local lsp_status = require('lsp-status')
lsp_status.register_progress()
-- config.capabilities = vim.tbl_extend('keep', config.capabilities or {}, lsp_status.capabilities)

-- Nicks
-- local lsp_status = require('lsp-status')
-- local capabilities = require('config.plugins.cmp').get_capabilities()
-- function M.get_capabilities()
-- 	return require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- end

-- lsp_status.register_progress()
-- capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)
-------------------------------------------------------------------------------
-- LSP
-------------------------------------------------------------------------------
-- Below are the three lines you need to run to install these
-- sudo npm i -g \
-- bash-language-server \
-- typescript \
-- typescript-language-server \
-- vim-language-server \
-- dockerfile-language-server-nodejs \
-- vscode-langservers-extracted \
-- pyright \
-- yarn

-- sudo yarn global add yaml-language-server

-- GO111MODULE=on go get golang.org/x/tools/gopls@latest
-- pip install jedi

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	--Enable completion triggered by <c-x><c-o>
	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	local opts = { noremap = true, silent = true }
	buf_set_keymap('n', '<leader>ca', '<cmd>Lspsaga code_action<CR>', opts)
	buf_set_keymap('n', '<leader>dn', '<cmd>Lspsaga diagnostic_jump_next<CR>', opts)
	buf_set_keymap('n', '<leader>dp', '<cmd>Lspsaga diagnostic_jump_prev<CR>', opts)
	buf_set_keymap('n', '<leader>lh', '<cmd>Lspsaga hover_doc<CR>', opts)
	buf_set_keymap('n', '<leader>lr', ':LspRestart<CR>', opts)
	buf_set_keymap('n', '<leader>ra', '<cmd>Lspsaga rename<CR>', opts)
	buf_set_keymap('n', '<leader>vd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', '<leader>vi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_set_keymap('n', '<leader>vr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
end

vim.g.coq_settings = {
	auto_start = 'shut-up',
	['keymap.jump_to_mark'] = '<S-Tab>',
}
local coq = require('coq')
---------------

local servers = {
	'bashls', -- npm i -g bash-language-server
	'dockerls', -- npm install -g dockerfile-language-server-nodejs
	'gopls', -- brew install golang; go install golang.org/x/tools/gopls@latest
	'html', -- sudo npm i -g vscode-langservers-extracted
	'jsonls', -- sudo npm i -g vscode-langservers-extracted
	'pyright', -- sudo npm install -g pyright
	'rust_analyzer', -- brew install rust-analyzer
	'sumneko_lua', -- brew install lua-language-server
	'terraformls', -- brew install hashicorp/tap/terraform-ls
	'tsserver', -- sudo npm install -g typescript typescript-language-server
	'vimls', -- sudo npm install -g vim-language-server
	'yamlls', -- npm install --global yarn; yarn global add yaml-language-server
}
local nvim_lsp = require('lspconfig')
---------------
for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup(coq.lsp_ensure_capabilities({
		on_attach = on_attach,
		flags = {
			debounce_text_changes = 150,
		},
	}))
end
