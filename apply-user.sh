#!/bin/sh
pushd ~/dotfiles-nix
nix build .#homeManagerConfigurations.jonas.activationPackage --extra-experimental-features flakes
./result/activate
popd
