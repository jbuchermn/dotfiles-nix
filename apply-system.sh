#!/bin/sh
pushd ~/dotfiles-nix
git add .
nixos-rebuild switch --flake .#
popd
