#!/usr/bin/env bash
nix-collect-garbage --delete-older-than 3d
sudo nix-collect-garbage --delete-older-than 3d

nix-store --gc --print-roots
sudo nix-store --gc --print-roots

nix store optimise
