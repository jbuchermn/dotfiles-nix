#!/bin/sh
git add .
nixos-rebuild switch --flake .#
