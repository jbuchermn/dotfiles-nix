#!/usr/bin/env bash
rev=$(nix registry list | grep nixpkgs | head -n1 | sed -n -e 's/^.*&rev=//p')
echo "Locking nixpkgs to rev $rev"
nix flake lock --override-input nixpkgs github:nixos/nixpkgs/$rev
