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
    --                              Remaps                              --
    ----------------------------------------------------------------------
    use {
        'LionC/nest.nvim',
        config = function()
            require 'config.remaps'
        end,
    }
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
    use 'sheerun/vim-polyglot' -- Syntax and other support for almost every programming language
    use {
        'williamboman/nvim-lsp-installer',
        event = 'BufEnter',
        after = 'cmp-nvim-lsp',
        config = "require('config.lsp')",
    }
    use 'tami5/lspsaga.nvim'
    use 'ray-x/lsp_signature.nvim'
    use 'simrat39/rust-tools.nvim' -- Inlay-Hints for rust
    -- " Debugging
    -- Plug 'nvim-lua/plenary.nvim'
    -- Plug 'mfussenegger/nvim-dap'
    ----------------------------------------------------------------------
    --                            Formatting                            --
    ----------------------------------------------------------------------
    use 'jose-elias-alvarez/null-ls.nvim'
    ----------------------------------------------------------------------
    --                            Treesitter                            --
    ----------------------------------------------------------------------
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            -- Additional parsers for Neorg (used to take notes)
            local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()
            parser_configs.norg_meta = {
                install_info = {
                    url = 'https://github.com/nvim-neorg/tree-sitter-norg-meta',
                    files = { 'src/parser.c' },
                    branch = 'main',
                },
            }
            parser_configs.norg_table = {
                install_info = {
                    url = 'https://github.com/nvim-neorg/tree-sitter-norg-table',
                    files = { 'src/parser.c' },
                    branch = 'main',
                },
            }
            require('nvim-treesitter.configs').setup {
                ensure_installed = {
                    'go',
                    'hcl',
                    'java',
                    'json',
                    'lua',
                    'make',
                    'norg',
                    'norg_meta',
                    'norg_table',
                    'python',
                    'rust',
                    'toml',
                    'yaml',
                },
                sync_install = false,
                indent = {
                    enabled = true,
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            }
        end,
    }
    use {
        'nvim-treesitter/nvim-treesitter-textobjects',
        requires = 'nvim-treesitter/nvim-treesitter',
        config = function()
            require('nvim-treesitter.configs').setup {
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            -- see after/queries/<language>/textobjects.scm for more capture groups
                            ['af'] = '@function.outer',
                            ['if'] = '@function.inner',
                            ['ac'] = '@class.outer',
                            ['ic'] = '@class.inner',
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ['<leader>mn'] = '@swappable',
                        },
                        swap_previous = {
                            ['<leader>mp'] = '@swappable',
                        },
                    },
                },
            }
        end,
    }
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
    ----------------------------------------------------------------------
    --                           Autocomplete                           --
    ----------------------------------------------------------------------
    use {
        'hrsh7th/nvim-cmp',
        branch = 'dev',
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
    use 'wellle/targets.vim' -- Better text object movement
    use 'tpope/vim-repeat' -- Repeat plugins with '.'
    use 'tpope/vim-abolish' -- Coercion between snake_case, camelCase, etc. (crs & crc)
    use 'tpope/vim-surround' -- Surround words
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
        'nvim-neorg/neorg',
        tag = '0.0.11',
        requires = { 'nvim-lua/plenary.nvim', 'nvim-neorg/neorg-telescope' },
        config = function()
            require('neorg').setup {
                load = {
                    ['core.defaults'] = {},
                    ['core.integrations.telescope'] = {},
                    ['core.keybinds'] = {
                        config = {
                            neorg_leader = ',',
                            hook = function(keybinds)
                                keybinds.unmap('norg', 'i', '<C-l>')
                            end,
                        },
                    },
                    ['core.norg.concealer'] = {},
                    ['core.norg.completion'] = {
                        config = {
                            engine = 'nvim-cmp',
                        },
                    },
                    ['core.norg.dirman'] = {
                        config = {
                            workspaces = {
                                notes = '~/neorg/notes',
                                tasks = '~/neorg/tasks',
                            },
                            autodetect = true,
                            autochdir = true,
                        },
                    },
                    ['core.gtd.base'] = {
                        config = {
                            workspace = 'tasks',
                        },
                    },
                    ['core.norg.qol.toc'] = {},
                },
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
    -- Worktrees
    -- use({ 'ThePrimeagen/git-worktree.nvim', requires = { 'nvim-telescope/telescope.nvim' } })
    -- use 'ThePrimeagen/git-worktree.nvim'
    -- Documentation
    use 'nanotee/luv-vimdocs'
    use 'milisims/nvim-luaref'
    -- TODO: Try remaping to this instead of lsp codeaction (remap to :lua CodeActionMenu<CR>)
    use { -- Code action menu with diffs
        'weilbith/nvim-code-action-menu',
        cmd = 'CodeActionMenu',
    }
end

local plugins = setmetatable({}, {
    __index = function(_, key)
        init()
        return packer[key]
    end,
})

return plugins
