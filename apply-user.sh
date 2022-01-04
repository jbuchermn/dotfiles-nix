#!/bin/sh
pushd ~/dotfiles-nix
nix build .#homeManagerConfigurations.jonas.activationPackage
./result/activate
popd
