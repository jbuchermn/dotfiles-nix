#!/bin/sh
pushd ~/dotfiles-nix
git add .
nixos-rebuild switch --flake .#nixosConfigurations.$1.config.system.build.toplevel
popd
