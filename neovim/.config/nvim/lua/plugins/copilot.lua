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
        branch = 'canary',
        dependencies = {
            'github/copilot.vim', -- or github/copilot.vim
            'nvim-lua/plenary.nvim', -- for curl, log wrapper
        },
        opts = {
            prompts = prompts,
            auto_follow_cursor = false, -- Don't follow the cursor after getting response
            show_help = true, -- Show help in virtual text
            debug = false, -- Enable debugging
            close = 'q', -- Close chat
            reset = '<C-l>', -- Clear the chat buffer
            complete = '<Tab>', -- Change to insert mode and press tab to get the completion
            submit_prompt = '<CR>', -- Submit question to Copilot Chat
            accept_diff = 'ga', -- Accept the diff
            show_diff = 'gd', -- Show the diff
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
            vim.keymap.set('n', '<leader>ac', '<cmd>CopilotChatInline<cr>', { silent = true, noremap = true })
        end,
    },
}
