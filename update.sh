#!/bin/sh
pushd ~/dotfiles-nix
nix flake update
popd
