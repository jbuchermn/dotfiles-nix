#!/bin/sh
pushd ~/dotfiles-nix
nix build .#homeManagerConfigurations.jonas-virtual.activationPackage
./result/activate
popd
