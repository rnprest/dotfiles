return {
    'neovim/nvim-lspconfig',
    {
        'nvimdev/lspsaga.nvim',
        config = function()
            require('lspsaga').setup {}
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter', -- optional
            'nvim-tree/nvim-web-devicons', -- optional
        },
    },
    'ray-x/lsp_signature.nvim',
    'simrat39/rust-tools.nvim', -- Inlay-Hints for rust
}
