# Ryan's dots

These are all of the files and settings that make my development environment as clean as a bean

### Neovim Screenshot

![isn't she beautiful?](images/neovim_config.png)

### Structure

I use [stow](https://www.gnu.org/software/stow/manual/stow.html) to manage my
dots, which is a symlink farm manager. Stow originated as a solution for
multiple programs sharing the same space for their config files, which it does
by just symlinking everything 1 directory back.

To illustrate: ripgrep expects a config file located at `$HOME/..ripgreprc`. Instead
of having my dots repo consist of a million obscure files like that, I can
organize them by program name (i.e. ripgrep) and run `stow ripgrep` inside my
dotfiles folder — symlinking the contents to my $HOME directory.

`lrwxr-xr-x 1 rnprest staff 21 Jun 28 10:17 ..ripgreprc -> dotfiles/ripgrep/..ripgreprc`

Neovim expects its config files to be located in $HOME/.config/nvim/<files>,
hence the nested appearance of that folder.

<a href="https://dotfyle.com/rnprest/dotfiles-neovim-config-nvim"><img src="https://dotfyle.com/rnprest/dotfiles-neovim-config-nvim/badges/plugins?style=flat" /></a>
<a href="https://dotfyle.com/rnprest/dotfiles-neovim-config-nvim"><img src="https://dotfyle.com/rnprest/dotfiles-neovim-config-nvim/badges/leaderkey?style=flat" /></a>
<a href="https://dotfyle.com/rnprest/dotfiles-neovim-config-nvim"><img src="https://dotfyle.com/rnprest/dotfiles-neovim-config-nvim/badges/plugin-manager?style=flat" /></a>

## Install Instructions

> Install requires Neovim 0.9+. Always review the code before installing a configuration.

Clone the repository and install the plugins:

```sh
git clone git@github.com:rnprest/dotfiles ~/.config/rnprest/dotfiles
NVIM_APPNAME=rnprest/dotfiles/neovim/.config/nvim nvim --headless +"Lazy! sync" +qa
```

Open Neovim with this config:

```sh
NVIM_APPNAME=rnprest/dotfiles/neovim/.config/nvim nvim
```

## Plugins

### bars-and-lines

- [SmiteshP/nvim-navic](https://dotfyle.com/plugins/SmiteshP/nvim-navic)

### color

- [NvChad/nvim-colorizer.lua](https://dotfyle.com/plugins/NvChad/nvim-colorizer.lua)

### colorscheme

- [marko-cerovac/material.nvim](https://dotfyle.com/plugins/marko-cerovac/material.nvim)

### colorscheme-creation

- [tjdevries/colorbuddy.nvim](https://dotfyle.com/plugins/tjdevries/colorbuddy.nvim)

### comment

- [s1n7ax/nvim-comment-frame](https://dotfyle.com/plugins/s1n7ax/nvim-comment-frame)
- [numToStr/Comment.nvim](https://dotfyle.com/plugins/numToStr/Comment.nvim)

### completion

- [hrsh7th/nvim-cmp](https://dotfyle.com/plugins/hrsh7th/nvim-cmp)
- [simrat39/rust-tools.nvim](https://dotfyle.com/plugins/simrat39/rust-tools.nvim)

### editing-support

- [nvim-treesitter/nvim-treesitter-context](https://dotfyle.com/plugins/nvim-treesitter/nvim-treesitter-context)
- [monaqa/dial.nvim](https://dotfyle.com/plugins/monaqa/dial.nvim)
- [johmsalas/text-case.nvim](https://dotfyle.com/plugins/johmsalas/text-case.nvim)
- [windwp/nvim-autopairs](https://dotfyle.com/plugins/windwp/nvim-autopairs)

### formatting

- [stevearc/conform.nvim](https://dotfyle.com/plugins/stevearc/conform.nvim)

### fuzzy-finder

- [nvim-telescope/telescope.nvim](https://dotfyle.com/plugins/nvim-telescope/telescope.nvim)

### git

- [f-person/git-blame.nvim](https://dotfyle.com/plugins/f-person/git-blame.nvim)
- [aaronhallaert/advanced-git-search.nvim](https://dotfyle.com/plugins/aaronhallaert/advanced-git-search.nvim)
- [lewis6991/gitsigns.nvim](https://dotfyle.com/plugins/lewis6991/gitsigns.nvim)

### icon

- [kyazdani42/nvim-web-devicons](https://dotfyle.com/plugins/kyazdani42/nvim-web-devicons)
- [nvim-tree/nvim-web-devicons](https://dotfyle.com/plugins/nvim-tree/nvim-web-devicons)

### lsp

- [j-hui/fidget.nvim](https://dotfyle.com/plugins/j-hui/fidget.nvim)
- [nvimdev/lspsaga.nvim](https://dotfyle.com/plugins/nvimdev/lspsaga.nvim)
- [ray-x/lsp_signature.nvim](https://dotfyle.com/plugins/ray-x/lsp_signature.nvim)
- [neovim/nvim-lspconfig](https://dotfyle.com/plugins/neovim/nvim-lspconfig)

### lsp-installer

- [williamboman/mason.nvim](https://dotfyle.com/plugins/williamboman/mason.nvim)

### marks

- [ThePrimeagen/harpoon](https://dotfyle.com/plugins/ThePrimeagen/harpoon)

### nvim-dev

- [nvim-lua/plenary.nvim](https://dotfyle.com/plugins/nvim-lua/plenary.nvim)
- [nvim-lua/popup.nvim](https://dotfyle.com/plugins/nvim-lua/popup.nvim)

### plugin-manager

- [folke/lazy.nvim](https://dotfyle.com/plugins/folke/lazy.nvim)

### quickfix

- [kevinhwang91/nvim-bqf](https://dotfyle.com/plugins/kevinhwang91/nvim-bqf)

### search

- [nvim-pack/nvim-spectre](https://dotfyle.com/plugins/nvim-pack/nvim-spectre)

### snippet

- [L3MON4D3/LuaSnip](https://dotfyle.com/plugins/L3MON4D3/LuaSnip)
- [rafamadriz/friendly-snippets](https://dotfyle.com/plugins/rafamadriz/friendly-snippets)

### statusline

- [nvim-lualine/lualine.nvim](https://dotfyle.com/plugins/nvim-lualine/lualine.nvim)

### syntax

- [nvim-treesitter/nvim-treesitter](https://dotfyle.com/plugins/nvim-treesitter/nvim-treesitter)

### utility

- [rcarriga/nvim-notify](https://dotfyle.com/plugins/rcarriga/nvim-notify)
- [michaelrommel/nvim-silicon](https://dotfyle.com/plugins/michaelrommel/nvim-silicon)
- [echasnovski/mini.nvim](https://dotfyle.com/plugins/echasnovski/mini.nvim)

## Language Servers

- bashls
- dockerls
- gopls
- html
- jsonls
- lua_ls
- ruff_lsp
- rust_analyzer
- sqlls
- terraformls
- tflint
- vimls
- yamlls

This readme was generated by [Dotfyle](https://dotfyle.com)

______________________________________________________________________

Font:

- HUGE fan of the [Iosevka](https://www.programmingfonts.org/#iosevka) font
  - make sure you download the [nerd-font](https://www.nerdfonts.com/font-downloads) version
  - my specific font is [Iosevka Nerd Font Complete Mono](https://github.com/rnprest/dotfiles/blob/main/misc/fonts/Iosevka%20Nerd%20Font%20Complete%20Mono.ttf)

GPG Signing:

- I use GPG signing on my commits. [Here's](https://zach.codes/setting-up-gpg-signing-for-github-on-mac/) how to set it up!

## Shoutout

If you're looking for some more dotfiles inspiration, then check out my friend
[Nick's](https://github.com/baileyn/dotfiles)!
