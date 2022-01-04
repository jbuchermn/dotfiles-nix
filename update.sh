#!/bin/sh
pushd ~/dotfiles-nix
nix flake update --recreate-lock-file
popd
