#!/bin/sh
pushd ~/dotfiles-nix
nixos-rebuild switch --flake .#
popd
