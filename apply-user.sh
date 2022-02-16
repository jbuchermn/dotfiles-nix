#!/bin/sh
pushd ~/dotfiles-nix
git add .
nix build .#homeManagerConfigurations.$1.activationPackage --extra-experimental-features flakes --extra-experimental-features nix-command && ./result/activate
popd
