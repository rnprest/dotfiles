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
    use 'lewis6991/impatient.nvim'
    use 'neovim/nvim-lspconfig'
    use 'godlygeek/tabular'
    use 'rhysd/clever-f.vim' -- Better f-movement - repeat w/ f or F
    use 'sheerun/vim-polyglot' -- Syntax and other support for almost every programming language
    use 'tpope/vim-abolish' -- Coercion between snake_case, camelCase, etc. (crs & crc)
    use 'tpope/vim-fugitive' -- Adds Gread, Gwrite, etc. all of which use buffer
    use 'tpope/vim-repeat' -- Repeat plugins with '.'
    use 'tpope/vim-surround' -- Surround words
    use 'wellle/targets.vim' -- Better text object movement
    use 'drewtempelmeyer/palenight.vim' -- Palenight theme
    use 'iamcco/markdown-preview.nvim' -- if on M1 mac, then need to 'yarn install && yarn upgrade' inside app directory
    -- Comments
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
    ----------
    use {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup()
        end,
    }
    -- Pretty keymaps
    use {
        'LionC/nest.nvim',
        config = function()
            require 'config.remaps'
        end,
    }
    use {
        'kyazdani42/nvim-web-devicons',
        config = function()
            require('nvim-web-devicons').setup()
        end,
    }
    use 'jose-elias-alvarez/null-ls.nvim'
    use {
        'rcarriga/nvim-notify',
        config = function()
            require('notify').setup {
                -- Animation style (see below for details)
                stages = 'fade_in_slide_out',
                -- Default timeout for notifications
                timeout = 1000,
                -- For stages that change opacity this is treated as the highlight behind the window
                -- Set this to either a highlight group or an RGB hex value e.g. "#000000"
                background_colour = 'Normal',
                -- Icons for the different levels
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
    use {
        'danymat/neogen',
        config = function()
            require('neogen').setup {
                enabled = true,
            }
        end,
        requires = 'nvim-treesitter/nvim-treesitter',
    }
    -- Translate color codes in terminal
    use {
        'norcalli/nvim-terminal.lua',
        config = function()
            require('terminal').setup()
        end,
    }
    -- Highlight color codes
    use {
        'norcalli/nvim-colorizer.lua',
        config = function()
            require('colorizer').setup()
        end,
    }
    -- Better increment/decrement
    use {
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
    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            ----------------------------------------------------------------------
            --                     add 2 parsers for neorg                      --
            ----------------------------------------------------------------------
            local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()
            -- These two are optional and provide syntax highlighting
            -- for Neorg tables and the @document.meta tag
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
                -- One of "all", "maintained" (parsers with maintainers), or a list of languages
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
                -- Install languages synchronously (only applied to `ensure_installed`)
                sync_install = false,

                indent = {
                    enabled = true,
                },

                highlight = {
                    -- `false` will disable the whole extension
                    enable = true,

                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = false,
                },
            }
        end,
    }
    use 'nvim-treesitter/playground'
    -- Colorschemes
    use {
        'marko-cerovac/material.nvim',
        requires = { 'tjdevries/colorbuddy.nvim' },
        config = function()
            vim.cmd 'colorscheme material'
            -- This highlight needs to load AFTER the colorscheme is set so that it isn't overwritten
            vim.cmd 'highlight CursorLineNr guifg=#fb801a'
            ----------------------------------------------------------------------
            --             Remove the underline from LspReference*              --
            ----------------------------------------------------------------------
            vim.cmd 'highlight LspReferenceRead gui=NONE guibg=#464B5D'
            vim.cmd 'highlight LspReferenceWrite gui=NONE guibg=#464B5D'
            vim.cmd 'highlight LspReferenceText gui=NONE guibg=#464B5D'
        end,
    }
    -- Statusline
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
        config = function()
            require('config.statusline').setup()
        end,
    }
    use 'j-hui/fidget.nvim'
    use {
        'lewis6991/gitsigns.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
        },
        config = function()
            require('gitsigns').setup()
        end,
    }
    -- Code action menu with diffs
    use {
        'weilbith/nvim-code-action-menu',
        cmd = 'CodeActionMenu',
    }
    -- LSP
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
    use { 'onsails/lspkind-nvim' }

    use {
        'williamboman/nvim-lsp-installer',
        event = 'BufEnter',
        after = 'cmp-nvim-lsp',
        config = "require('config.lsp')",
    }

    use { 'tami5/lspsaga.nvim', branch = 'nvim51' }
    use { 'ray-x/lsp_signature.nvim' }

    -- luasnip ❤️   cmp
    use { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' }
    use { 'L3MON4D3/LuaSnip', requires = { 'rafamadriz/friendly-snippets' }, after = 'cmp_luasnip' }
    -- Telescope
    use {
        'nvim-telescope/telescope.nvim',
        requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-fzy-native.nvim' },
        config = function()
            require 'config.telescope'
        end,
    }
    -- use({ 'ThePrimeagen/git-worktree.nvim', requires = { 'nvim-telescope/telescope.nvim' } })
    use { 'nvim-telescope/telescope-file-browser.nvim', requires = { 'nvim-telescope/telescope.nvim' } }
    -- Harpoon
    use {
        'ThePrimeagen/harpoon',
        requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
    }
    -- Task Warrior / Vim Wiki
    use { 'vimwiki/vimwiki', branch = 'dev' }
    use {
        'nvim-neorg/neorg',
        -- tag = '0.0.11',
        requires = { 'nvim-lua/plenary.nvim', 'nvim-neorg/neorg-telescope' },
        config = function()
            require('neorg').setup {
                load = {
                    ['core.defaults'] = {},
                    ['core.integrations.telescope'] = {},
                    ['core.keybinds'] = {
                        config = {
                            neorg_leader = ',',
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
                    ['core.presenter'] = {
                        config = {
                            zen_mode = 'zen-mode',
                        },
                    },
                    ['core.norg.qol.toc'] = {},
                },
            }
        end,
    }
    -- Lua
    use {
        'folke/zen-mode.nvim',
        config = function()
            require('zen-mode').setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end,
    }
    -- Refactoring
    use {
        'ThePrimeagen/refactoring.nvim',
        requires = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
        config = function()
            require('refactoring').setup {}
        end,
    }
    use {
        'SmiteshP/nvim-gps',
        requires = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            require('nvim-gps').setup()
        end,
    }
    use {
        'ruifm/gitlinker.nvim',
        requires = 'nvim-lua/plenary.nvim',
        config = function()
            require 'config.gitlinker'
        end,
    }
    -- I'm weak and still need this
    use 'ThePrimeagen/git-worktree.nvim'
    use 'nanotee/luv-vimdocs'
    use 'milisims/nvim-luaref'
end

local plugins = setmetatable({}, {
    __index = function(_, key)
        init()
        return packer[key]
    end,
})

return plugins
