# Setup NixOS

Follow NixOS manual, be sure to setup
- Networking / Wireless
- Hostname
- User and password
- `nix flake`
- `(n)vim`
- `git`

on first setup. Then clone this repo and
- possibly add entry for hostname adding new folder under `system`,
- possibly add entry for user adding new folder under `users`,
- check / update `hardware-configuration.nix`.

Then apply.

# Build install medium

```sh
nix build .#nixosConfigurations.jb-nixos-live.config.system.build.isoImage
```

# Full update

```sh
./update.sh && ./apply-user.sh jonas-nixos [jonas-mbp / ...] && sudo ./apply-system.sh
```

# ToDo

- [ ] Add home-manager and nixos-options to nix-search
- [X] Ensure `nix shell` and setting up a flake initially uses the systems nixpkgs: `nix-flake-lock-nixpkgs`
- [X] Fix nix-search format for "nix search" instead of "nix-env -qaP"

## General

- [ ] newm-sidecar
- [X] gsync
- [ ] macho
- [ ] vaapi

## (n)ViM

- [x] Jumping around when errors appear and disappear
- [x] Autocomplete
- [ ] Bar at bottom
- [ ] vsnips
- [ ] Tree-sitter grammar for org requires `:TSUpdate` - not nice


## Temporary hacks fixing nixos-unstable bugs

- Haskell-Language-Server currently disabled (does not build on ARM)
