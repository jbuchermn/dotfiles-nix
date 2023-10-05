#!/usr/bin/env bash
cd $(nix registry list | grep nixpkgs | head -n1 | sed -e 's/^.*path:\(.*\)?.*/\1/') && vim
