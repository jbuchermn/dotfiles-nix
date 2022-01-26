# Setup NixOS

Follow NixOS manual, be sure to setup
- Networking / Wireless
- Hostname
- User and password
- `nix flake`
- `vim`
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

- [ ] Fix nix-search for flakes (shows outdated results as it is)
- [ ] Add home-manager and nixos-options to nix-search

## General

- [ ] newm-sidecar
- [ ] gsync
- [ ] macho

## ViM

- [x] Jumping around when errors appear and disappear
- [x] Autocomplete
- [ ] Bar at bottom
- [ ] vsnips
