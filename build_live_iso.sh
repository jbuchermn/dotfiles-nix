#!/bin/sh
nix build .#nixosConfigurations.jb-nixos-live.config.system.build.isoImage
