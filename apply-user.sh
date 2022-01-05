#!/bin/sh
pushd ~/dotfiles-nix
git add .
nix build .#homeManagerConfigurations.jonas-nixos-virtual.activationPackage --extra-experimental-features flakes
./result/activate
popd
