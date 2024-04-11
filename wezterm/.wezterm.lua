local wezterm = require 'wezterm'
local act = wezterm.action
return {
    ----------------------------------------------------------------------
    --                          Font Settings                           --
    ----------------------------------------------------------------------
    font = wezterm.font('Iosevka Nerd Font Mono', { stretch = 'Normal', style = 'Normal', weight = 'Bold' }),
    font_size = 16,
    adjust_window_size_when_changing_font_size = false,
    ----------------------------------------------------------------------
    --                       Background Settings                        --
    ----------------------------------------------------------------------
    window_background_opacity = 0.75,
    macos_window_background_blur = 20,
    hide_tab_bar_if_only_one_tab = true,
    window_padding = {
        -- Feels weird to have no left padding :/
        right = 0,
        top = 0,
        bottom = 0,
    },
    ----------------------------------------------------------------------
    --                              Remaps                              --
    ----------------------------------------------------------------------
    keys = {
        { key = '+', mods = 'CMD', action = act.IncreaseFontSize }, -- see 'adjust_window_size_when_changing_font_size'
        { key = '-', mods = 'CMD', action = act.DecreaseFontSize }, -- see 'adjust_window_size_when_changing_font_size'
        { key = '0', mods = 'CMD', action = act.ResetFontSize }, -- see 'adjust_window_size_when_changing_font_size'
        { key = 'q', mods = 'CMD', action = act.CloseCurrentPane { confirm = false } },
        { key = 'C', mods = 'CMD', action = act.CopyTo 'ClipboardAndPrimarySelection' },
        { key = 'UpArrow', mods = 'SHIFT', action = act.ScrollToPrompt(-1) },
        { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollToPrompt(1) },
        { key = 'F14', mods = '', action = wezterm.action.Nop },
    },
    ----------------------------------------------------------------------
    --                            Hyperlinks                            --
    ----------------------------------------------------------------------
    mouse_bindings = {
        -- Change the default click behavior so that it only selects
        -- text and doesn't open hyperlinks
        {
            event = { Up = { streak = 1, button = 'Left' } },
            mods = 'NONE',
            action = act.CompleteSelection 'PrimarySelection',
        },

        -- and make CTRL-Click open hyperlinks
        {
            event = { Up = { streak = 1, button = 'Left' } },
            mods = 'CTRL',
            action = act.OpenLinkAtMouseCursor,
        },
    },
    hyperlink_rules = {
        -- Make username/project paths clickable. This implies paths like the following are for GitHub.
        -- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wez/wezterm | "wez/wezterm.git" )
        -- As long as a full URL hyperlink regex exists above this it should not match a full URL to
        -- GitHub or GitLab / BitBucket (i.e. https://gitlab.com/user/project.git is still a whole clickable URL)
        {
            regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
            format = 'https://www.github.com/$1/$3',
        },
        -- Linkify things that look like URLs and the host has a TLD name.
        {
            regex = '\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b',
            format = '$0',
        },
        -- Linkify email addresses
        {
            regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
            format = 'mailto:$0',
        },
        -- file:// URI
        {
            regex = [[\bfile://\S*\b]],
            format = '$0',
        },
        -- Linkify things that look like URLs with numeric addresses as hosts.
        -- E.g. http://127.0.0.1:8000 for a local development server,
        {
            regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
            format = '$0',
        },
    },
}
