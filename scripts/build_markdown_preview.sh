#!/bin/bash

pushd ~/.local/share/nvim/site/pack/packer/start/markdown-preview.nvim/
yarn install && yarn upgrade
popd
