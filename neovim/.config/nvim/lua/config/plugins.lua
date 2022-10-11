local execute = vim.api.nvim_command
local packer = nil
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local compile_path = install_path .. '/plugin/packer_compiled.lua'
local is_installed = vim.fn.empty(vim.fn.glob(install_path)) == 0

local function init()
    if not is_installed then
        if vim.fn.input 'Install packer.nvim? (y for yes) ' == 'y' then
            execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
            execute 'packadd packer.nvim'
            print 'Installed packer.nvim.'
            is_installed = 1
        end
    end

    if not is_installed then
        return
    end
    if packer == nil then
        packer = require 'packer'
        packer.init {
            disable_commands = true,
            compile_path = compile_path,
        }
    end

    local use = packer.use
    packer.reset()

    use 'wbthomason/packer.nvim' -- Which came first? The chicken or the egg?
    use 'lewis6991/impatient.nvim' -- Improves startup time for neovim
    ----------------------------------------------------------------------
    --                               Git                                --
    ----------------------------------------------------------------------
    use 'tpope/vim-fugitive'
    use {
        'lewis6991/gitsigns.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
        },
        config = function()
            require('gitsigns').setup()
        end,
    }
    use {
        'ruifm/gitlinker.nvim',
        requires = 'nvim-lua/plenary.nvim',
        config = function()
            require 'config.gitlinker'
        end,
    }
    ----------------------------------------------------------------------
    --                           LSP / Syntax                           --
    ----------------------------------------------------------------------
    use 'neovim/nvim-lspconfig'
    use {
        'williamboman/mason.nvim',
        after = 'cmp-nvim-lsp',
        requires = { 'williamboman/mason-lspconfig.nvim' },
        config = "require('config.lsp')",
    }
    use 'tami5/lspsaga.nvim'
    use 'ray-x/lsp_signature.nvim'
    use 'simrat39/rust-tools.nvim' -- Inlay-Hints for rust
    use {
        'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
        config = function()
            require('lsp_lines').setup()

            -- start nvim with virtual text on, but lines disabled
            vim.diagnostic.config {
                virtual_text = true,
                virtual_lines = false,
            }
            -- toggle lsp lines
            vim.keymap.set('n', '<leader>lt', function()
                local virtual_lines_enabled = not vim.diagnostic.config().virtual_lines
                vim.diagnostic.config {
                    virtual_lines = virtual_lines_enabled,
                    virtual_text = not virtual_lines_enabled,
                }
            end)
        end,
    }
    -- " Debugging
    -- Plug 'nvim-lua/plenary.nvim'
    -- Plug 'mfussenegger/nvim-dap'
    ----------------------------------------------------------------------
    --                            Formatting                            --
    ----------------------------------------------------------------------
    use {
        'jose-elias-alvarez/null-ls.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
    }

    ----------------------------------------------------------------------
    --                            Treesitter                            --
    ----------------------------------------------------------------------
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                auto_install = true,
                indent = {
                    enabled = true,
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = { 'org' },
                },
            }
        end,
    }
    use {
        'nvim-treesitter/nvim-treesitter-context',
        requires = 'nvim-treesitter/nvim-treesitter',
        config = function()
            -- This will be overwritten if I don't have it in the ColorScheme autocmd
            vim.api.nvim_create_autocmd('ColorScheme', {
                callback = function()
                    vim.api.nvim_set_hl(0, 'TreesitterContext', { bg = '#3E5256' }) -- 5% lighter that CursorLine hl group
                end,
            })
        end,
    }

    use 'Afourcat/treesitter-terraform-doc.nvim' -- open terraform docs for current resource/data block

    use 'nvim-treesitter/playground'
    ----------------------------------------------------------------------
    --                            Telescope                             --
    ----------------------------------------------------------------------
    use {
        'nvim-telescope/telescope.nvim',
        requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-fzy-native.nvim' },
        config = function()
            require 'config.telescope'
        end,
    }
    use { 'nvim-telescope/telescope-ui-select.nvim', requires = { 'nvim-telescope/telescope.nvim' } }
    use { 'nvim-telescope/telescope-file-browser.nvim', requires = { 'nvim-telescope/telescope.nvim' } }
    use { 'nvim-telescope/telescope-live-grep-args.nvim', requires = { 'nvim-telescope/telescope.nvim' } }
    use { 'ThePrimeagen/git-worktree.nvim', requires = { 'nvim-telescope/telescope.nvim' } }
    use { 'LinArcX/telescope-env.nvim', requires = { 'nvim-telescope/telescope.nvim' } }
    ----------------------------------------------------------------------
    --                           Autocomplete                           --
    ----------------------------------------------------------------------
    use {
        'hrsh7th/nvim-cmp',
        -- branch = 'dev',
        event = 'BufEnter',
        config = function()
            require('config.cmp').setup()
        end,
    }
    use { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-path', after = 'nvim-cmp' }
    ----------------------------------------------------------------------
    --                             Snippets                             --
    ----------------------------------------------------------------------
    use { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' }
    use {
        'L3MON4D3/LuaSnip',
        requires = { 'rafamadriz/friendly-snippets' },
        after = 'cmp_luasnip',
        config = function()
            require 'config.luasnip'
        end,
    }
    ----------------------------------------------------------------------
    --                             Display                              --
    ----------------------------------------------------------------------
    use {
        'kyazdani42/nvim-web-devicons',
        config = function()
            require('nvim-web-devicons').setup()
        end,
    }
    use {
        'rcarriga/nvim-notify',
        config = function()
            require('notify').setup {
                stages = 'fade_in_slide_out',
                timeout = 1000,
                background_colour = 'Normal',
                icons = {
                    ERROR = '',
                    WARN = '',
                    INFO = '',
                    DEBUG = '',
                    TRACE = '✎',
                },
            }
            vim.notify = require 'notify'
        end,
    }
    use 'onsails/lspkind-nvim' -- Adds symbols to lsp completion menu
    use { -- Highlight color codes
        'norcalli/nvim-colorizer.lua',
        config = function()
            require('colorizer').setup()
        end,
    }
    use {
        'marko-cerovac/material.nvim',
        requires = 'tjdevries/colorbuddy.nvim',
        config = function()
            vim.cmd 'colorscheme material'
            -- This highlight needs to load AFTER the colorscheme is set so that it isn't overwritten
            vim.cmd 'highlight CursorLineNr guifg=#fb801a'
            -- Remove the underline from LspReference* (for CursorHold aucmd)
            vim.cmd 'highlight LspReferenceRead gui=NONE guibg=#464B5D'
            vim.cmd 'highlight LspReferenceWrite gui=NONE guibg=#464B5D'
            vim.cmd 'highlight LspReferenceText gui=NONE guibg=#464B5D'
        end,
    }
    ----------------------------------------------------------------------
    --                            Statusline                            --
    ----------------------------------------------------------------------
    use { -- Statusline
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
        config = function()
            require('config.statusline').setup()
        end,
    }
    use 'j-hui/fidget.nvim'
    -- Show breadcrumbs in statusline
    use {
        'SmiteshP/nvim-gps',
        requires = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            require('nvim-gps').setup()
        end,
    }
    ----------------------------------------------------------------------
    --                        Text Manipulation                         --
    ----------------------------------------------------------------------
    use { -- aligning text (<count>gl(L)<motion><char>)
        'tommcdo/vim-lion',
        config = function()
            vim.cmd 'let b:lion_squeeze_spaces = 1'
        end,
    }
    use 'wellle/targets.vim' -- Better text object movement
    use 'tpope/vim-repeat' -- Repeat plugins with '.'
    use 'tpope/vim-abolish' -- Coercion between snake_case, camelCase, etc. (crs & crc)
    use {
        'kylechui/nvim-surround',
        config = function()
            require('nvim-surround').setup {
                -- Configuration here, or leave empty to use defaults
            }
        end,
    }
    use {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup()
        end,
    }
    use { -- Better increment/decrement
        'monaqa/dial.nvim',
        config = function()
            vim.api.nvim_set_keymap('n', '<C-a>', require('dial.map').inc_normal(), { noremap = true })
            vim.api.nvim_set_keymap('n', '<C-x>', require('dial.map').dec_normal(), { noremap = true })
            vim.api.nvim_set_keymap('v', '<C-a>', require('dial.map').inc_visual(), { noremap = true })
            vim.api.nvim_set_keymap('v', '<C-x>', require('dial.map').dec_visual(), { noremap = true })
            vim.api.nvim_set_keymap('v', 'g<C-a>', require('dial.map').inc_gvisual(), { noremap = true })
            vim.api.nvim_set_keymap('v', 'g<C-x>', require('dial.map').dec_gvisual(), { noremap = true })
        end,
    }
    use {
        'ThePrimeagen/refactoring.nvim',
        requires = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
        config = function()
            require('refactoring').setup {}
        end,
    }
    ----------------------------------------------------------------------
    --                             Comments                             --
    ----------------------------------------------------------------------
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup {
                ignore = '^$',
            }
        end,
    }
    use {
        's1n7ax/nvim-comment-frame',
        requires = {
            { 'nvim-treesitter' },
        },
        config = function()
            require('nvim-comment-frame').setup()
        end,
    }
    use {
        'danymat/neogen',
        config = function()
            require('neogen').setup {
                enabled = true,
            }
        end,
        requires = 'nvim-treesitter/nvim-treesitter',
    }
    ----------------------------------------------------------------------
    --                              Notes                               --
    ----------------------------------------------------------------------
    use {
        'nvim-orgmode/orgmode',
        requires = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            require('orgmode').setup_ts_grammar()
            require('orgmode').setup {
                org_agenda_files = { '~/notes/**/*' },
                org_default_notes_file = '~/notes/org/refile.org',
                win_split_mode = 'float',
            }
        end,
    }
    ----------------------------------------------------------------------
    --                          Miscellaneous                           --
    ----------------------------------------------------------------------
    use {
        'ThePrimeagen/harpoon',
        requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
    }
    -- Documentation
    use 'nanotee/luv-vimdocs'
    use 'milisims/nvim-luaref'
    -- TODO: Try remaping to this instead of lsp codeaction (remap to :lua CodeActionMenu<CR>)
    use { -- Code action menu with diffs
        'weilbith/nvim-code-action-menu',
        cmd = 'CodeActionMenu',
    }
    -- Call :FeMaco with cursor on a markdown code-block to edit with proper lsp
    use {
        'AckslD/nvim-FeMaco.lua',
        config = 'require("femaco").setup()',
    }
end

local plugins = setmetatable({}, {
    __index = function(_, key)
        init()
        return packer[key]
    end,
})

return plugins
