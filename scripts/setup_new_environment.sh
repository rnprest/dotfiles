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
brew services start skhd
popd

###############################################################################
# Stow
###############################################################################
echo "Stowing neovim, skhd, and personal"
# Remove gitconfig because it will be overwritten by personal
rm ~/.gitconfig
pushd ~/dotfiles/
stow neovim skhd personal
popd

###############################################################################
# Neovim LSPs
###############################################################################
echo "Installing language servers"
pushd ~/dotfiles/scripts/
./install_LSPs.sh
popd

###############################################################################
# Neovim
###############################################################################
echo "Installing neovim and running :PackerInstall"
pip3 install neovim
cargo install stylua # For formatting .lua files
# Install plugins
nvim ~/dotfiles/neovim/.config/nvim/lua/config/plugins.lua +PackerInstall
