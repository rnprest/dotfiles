#!/bin/bash

# Installation instructions can be found here:
# https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

echo "Installing the bashls language server"
npm i -g bash-language-server
echo "Installing the dockerls language server"
npm install -g dockerfile-language-server-nodejs
echo "Installing the gopls language server"
brew install golang; go install golang.org/x/tools/gopls@latest
echo "Installing the html language server"
sudo npm i -g vscode-langservers-extracted
echo "Installing the jsonls language server"
sudo npm i -g vscode-langservers-extracted
echo "Installing the pyright language server"
sudo npm install -g pyright
echo "Installing the rust_analyzer language server"
brew install rust-analyzer
echo "Installing the terraformls language server"
brew install hashicorp/tap/terraform-ls
echo "Installing the tsserver language server"
sudo npm install -g typescript typescript-language-server
echo "Installing the vimls language server"
sudo npm install -g vim-language-server
echo "Installing the yamlls language server"
npm install --global yarn; yarn global add yaml-language-server
