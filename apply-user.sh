#!/bin/sh
pushd ~/dotfiles-nix
nix build .#homeManagerConfigurations.jonas-nixos-virtual.activationPackage --extra-experimental-features flakes
./result/activate
popd
