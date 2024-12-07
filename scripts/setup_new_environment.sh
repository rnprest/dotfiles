#!/bin/bash

###############################################################################
# Mac settings
###############################################################################
echo "Changing mac settings"
pushd ~/dotfiles/scripts/
./mac_settings.sh
popd

###############################################################################
# Homebrew
###############################################################################
echo "Installing Homebrew and formulae/casks"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
pushd ~/dotfiles/Homebrew/
brew bundle
popd

###############################################################################
# Stow
###############################################################################
echo "Stowing neovim, ripgrep, tmux, and wezterm"
pushd ~/dotfiles/
stow neovim ripgrep tmux wezterm
popd
