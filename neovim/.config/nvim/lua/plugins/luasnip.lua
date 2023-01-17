return {
    'L3MON4D3/LuaSnip',
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
        local ls = require 'luasnip'
        local types = require 'luasnip.util.types'

        ls.config.set_config {
            -- This tells LuaSnip to remember to keep around the last snippet.
            -- You can jump back into it even if you move outside of the selection
            history = true,

            -- This one is cool cause if you have dynamic snippets, it updates as you type!
            updateevents = 'TextChanged,TextChangedI',

            -- Autosnippets:
            enable_autosnippets = true,

            ext_opts = {
                [types.choiceNode] = {
                    active = {
                        virt_text = { { '<-- Current Choice', 'White' } },
                    },
                },
            },
        }

        -- <c-k> is my expansion key
        -- this will expand the current item or jump to the next item within the snippet
        vim.keymap.set({ 'i', 's' }, '<c-k>', function()
            if ls.expand_or_jumpable() then
                ls.expand_or_jump()
            end
        end, { silent = true })

        -- <c-j> is my jump backwards key
        -- this always moves to the previous item within the snippet
        vim.keymap.set({ 'i', 's' }, '<c-j>', function()
            if ls.jumpable(-1) then
                ls.jump(-1)
            end
        end, { silent = true })

        -- <c-l> is selecting within a list of options
        -- this is useful for choice nodes
        vim.keymap.set('i', '<c-l>', function()
            if ls.choice_active() then
                ls.change_choice(-1)
            end
        end)

        vim.keymap.set('i', '<c-u>', require 'luasnip.extras.select_choice')

        ----------------------------------------------------------------------
        --                             Snippets                             --
        ----------------------------------------------------------------------

        local s, i, t, c, f, d, sn =
        ls.s, ls.insert_node, ls.text_node, ls.choice_node, ls.function_node, ls.dynamic_node, ls.sn
        local fmt = require('luasnip.extras.fmt').fmt
        local rep = require('luasnip.extras').rep

        local same = function(index)
            return f(function(arg)
                return arg[1]
            end, { index })
        end

        local get_test_result = function(position)
            return d(position, function()
                local nodes = {}
                table.insert(nodes, t '')

                local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                for _, line in ipairs(lines) do
                    if line:match 'anyhow::Result' then
                        table.insert(nodes, t ' -> Result<()> ')
                        break
                    end
                end
                table.insert(nodes, t ' -> Result<(),()>')
                table.insert(nodes, t 'something')
                table.insert(nodes, t 'final')
                return sn(nil, c(1, nodes))
            end, {})
        end

        ls.add_snippets(nil, {
            all = {
                s('sametest', fmt([[example: {}, function: {}]], { i(1), same(1) })),
                s(
                    'curtime',
                    f(function()
                        return os.date '%D - %H:%M'
                    end)
                ),
                s('todo', {
                    c(1, {
                        t 'TODO(rpreston): ',
                        t 'FIX(rpreston): ',
                        t 'NOTE(rpreston): ',
                        t 'TODO(anybody please help me): ',
                    }),
                }),
            },
            rust = {
                -- Debug format
                s('debug', { t '{:#?}' }),
                -- print the contents of a variable
                s('print', fmt([[ println!("{} = {{:#?}}", &{}); ]], { i(1, 'variable_name'), rep(1) })),
                -- implement display for a type
                s(
                    'impldisplay',
                    fmt(
                        [[
                impl fmt::Display for {} {{
                    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {{
                        write!(f, "{}", {})
                    }}
                }}
                ]]       ,
                        {
                            i(1, 'type'),
                            i(2),
                            i(0),
                        }
                    )
                ),
                -- adding a test case
                s(
                    'test',
                    fmt(
                        [[
                #[test]
                fn {}(){}{{
                    {}
                }}
            ]]           ,
                        {
                            i(1, 'testname'),
                            get_test_result(2),
                            i(0),
                        }
                    )
                ),
                -- adding a test module
                s(
                    'modtest',
                    fmt(
                        [[
                #[cfg(test)]
                mod test {{
                {}

                    {}
                }}
                ]]       ,
                        {
                            c(1, { t '    use super::*;', t '' }),
                            i(0),
                        }
                    )
                ),
                -- populate a mod.rs file
                s(
                    'mod.rs',
                    fmt(
                        [[
                mod {};

                pub use {}::*;
                ]]       ,
                        { i(1, '<name of the rust file in this module>'), rep(1) }
                    )
                ),
            },
            lua = {
                -- local builtin = require "telescope.pickers.builtin"
                s(
                    'req',
                    fmt([[local {} = require "{}"]], {
                        f(function(import_name)
                            local parts = vim.split(import_name[1][1], '.', true)
                            return parts[#parts] or ''
                        end, { 1 }),
                        i(1),
                    })
                ),
                s('oldreq', fmt("local {} = require('{}')", { i(1, 'default'), rep(1) })),
                s('lf', fmt('local {} = function({})\n    {}\nend', { i(1), i(2), i(0) })),
            },
            norg = {
                s('page', fmt([[ {{:{}:}}[{}] ]], { i(1), i(0) })),
            },
            sh = {
                -- check if an environment variable exists
                s(
                    'varexists',
                    fmt(
                        [[
                if [ -z ${} ]; then
                    echo "Please set the {} env var in your shell"
                    exit 1
                fi
                ]]       ,
                        {
                            i(1, 'ENV_VAR_NAME'),
                            rep(1),
                        }
                    )
                ),
            },
            go = {
                -- handle errors
                s(
                    'iferr',
                    fmt(
                        [[
                if err != nil {{
                    log.Fatalf("Error: %v", err)
                }}
                {}
                ]]       ,
                        {
                            i(0),
                        }
                    )
                ),

                s(
                    'range',
                    fmt(

                        [[
                for _, {} := range {} {{
                    {}
                }}
                ]]       ,
                        {
                            i(1),
                            i(2),
                            i(0),
                        }
                    )
                ),

                -- print the contents of a variable
                s('print', fmt([[ log.Printf("{} = %v", {}) ]], { i(1, 'variable_name'), rep(1) })),
            },
        })
    end,
}
