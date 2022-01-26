#!/usr/bin/env bash
nix search nixpkgs --json | jq '[to_entries | .[] | {name:.key[28:], pname:.value.pname, version:.value.version, description:.value.description[:50]}] | map("\u001b[1m\u001b[34m\(.name)\u001b[0m\t\u001b[32m\(.version)\u001b[0m\t\u001b[90m\(.description)\u001b[0m\t") | .[]' -r | column -t -s $'\t' | fzf --ansi
