return {
    'neovim/nvim-lspconfig',
    'tami5/lspsaga.nvim',
    'ray-x/lsp_signature.nvim',
    'simrat39/rust-tools.nvim', -- Inlay-Hints for rust

    {
        'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
        config = function()
            require('lsp_lines').setup()
            -- start nvim with virtual text on, but lines disabled
            vim.diagnostic.config {
                virtual_text = true,
                virtual_lines = false,
            }
        end,
        keys = {
            {
                -- toggle lsp lines
                '<leader>lt',
                function()
                    local virtual_lines_enabled = not vim.diagnostic.config().virtual_lines
                    vim.diagnostic.config {
                        virtual_lines = virtual_lines_enabled,
                        virtual_text = not virtual_lines_enabled,
                    }
                end,
                silent = true,
                noremap = true,
            },
        },
    },
}
