local prompts = {
    -- Code related prompts
    Explain = 'Please explain how the following code works.',
    Review = 'Please review the following code and provide suggestions for improvement.',
    Tests = 'Please explain how the selected code works, then generate unit tests for it.',
    Refactor = 'Please refactor the following code to improve its clarity and readability.',
    FixCode = 'Please fix the following code to make it work as intended.',
    FixError = 'Please explain the error in the following text and provide a solution.',
    BetterNamings = 'Please provide better names for the following variables and functions.',
    Documentation = 'Please provide documentation for the following code.',
    -- Text related prompts
    Summarize = 'Please summarize the following text.',
    Spelling = 'Please correct any grammar and spelling errors in the following text.',
    Wording = 'Please improve the grammar and wording of the following text.',
    Concise = 'Please rewrite the following text to make it more concise.',
}

return {
    {
        'github/copilot.vim',
        config = function()
            vim.keymap.set('i', '<leader>co', 'copilot#Accept("")', {
                expr = true,
                replace_keycodes = false,
            })
            vim.g.copilot_no_tab_map = true
        end,
    },
    {
        'CopilotC-Nvim/CopilotChat.nvim',
        version = 'v2.3.0',
        dependencies = {
            'nvim-telescope/telescope.nvim', -- for telescope integration
            'github/copilot.vim', -- or github/copilot.vim
            'nvim-lua/plenary.nvim', -- for curl, log wrapper
        },
        opts = {
            prompts = prompts,
            auto_follow_cursor = false, -- Don't follow the cursor after getting response
            show_help = false, -- Show help in virtual text
            debug = false, -- Enable debugging
            mappings = {
                -- Use tab for completion
                complete = {
                    detail = 'Use @<Tab> or /<Tab> for options.',
                    insert = '<Tab>',
                },
                -- Close the chat
                close = {
                    normal = 'q',
                    insert = '<C-c>',
                },
                -- Reset the chat buffer
                reset = {
                    normal = '<C-l>',
                    insert = '<C-l>',
                },
                -- Submit the prompt to Copilot
                submit_prompt = {
                    normal = '<CR>',
                    insert = '<C-CR>',
                },
                -- Accept the diff
                accept_diff = {
                    normal = 'ga',
                    insert = 'ga',
                },
                -- Show the diff
                show_diff = {
                    normal = 'gd',
                },
                -- Show the prompt
                show_system_prompt = {
                    normal = 'gmp',
                },
                -- Show the user selection
                show_user_selection = {
                    normal = 'gms',
                },
            },
        },
        event = 'VeryLazy',
        config = function(_, opts)
            local chat = require 'CopilotChat'
            local select = require 'CopilotChat.select'
            -- Use unnamed register for the selection
            opts.selection = select.unnamed
            chat.setup(opts)

            -- Inline chat with Copilot
            vim.api.nvim_create_user_command('CopilotChatInline', function(args)
                chat.ask(args.args, {
                    selection = select.visual,
                    window = {
                        layout = 'float',
                        relative = 'cursor',
                        width = 1,
                        height = 0.4,
                        row = 1,
                    },
                })
            end, { nargs = '*', range = true })

            ----------------------------------------------------------------------
            --                              Remaps                              --
            ----------------------------------------------------------------------
            vim.keymap.set('n', '<leader>ap', function()
                local actions = require 'CopilotChat.actions'
                require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
            end, { silent = true, noremap = true })
            vim.keymap.set('n', '<leader>ae', '<cmd>CopilotChatExplain<cr>', { silent = true, noremap = true })
            vim.keymap.set('n', '<leader>at', '<cmd>CopilotChatTests<cr>', { silent = true, noremap = true })
            vim.keymap.set('n', '<leader>ar', '<cmd>CopilotChatReview<cr>', { silent = true, noremap = true })
            vim.keymap.set('n', '<leader>aR', '<cmd>CopilotChatRefactor<cr>', { silent = true, noremap = true })
            vim.keymap.set('n', '<leader>an', '<cmd>CopilotChatBetterNamings<cr>', { silent = true, noremap = true })
            vim.keymap.set('n', '<leader>ad', '<cmd>CopilotChatDebugInfo<cr>', { silent = true, noremap = true })
            vim.keymap.set('n', '<leader>af', '<cmd>CopilotChatFixDiagnostic<cr>', { silent = true, noremap = true })
            vim.keymap.set('n', '<leader>al', '<cmd>CopilotChatReset<cr>', { silent = true, noremap = true })
            vim.keymap.set('n', '<leader>ai', '<cmd>CopilotChatInline<cr>', { silent = true, noremap = true })
            vim.keymap.set('n', '<leader>ac', '<cmd>CopilotChatCommitStaged<cr>', { silent = true, noremap = true })
            vim.keymap.set('n', '<leader>ab', function()
                local input = vim.fn.input 'Quick Chat: '
                if input ~= '' then
                    require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
                end
            end, { silent = true, noremap = true })
        end,
    },
}
