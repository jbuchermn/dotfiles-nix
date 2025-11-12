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

See [nixos-generators](https://github.com/nix-community/nixos-generators)

```sh
nix build .#nixosConfigurations.jb-nixos-live.config.formats.[raw|raw-efi|install-iso]
```

# Full update

```sh
./update.sh && ./apply-user.sh jonas-nixos [jonas-mbp / ...] && sudo ./apply-system.sh
```

# Notes

- `nix flake show`
- `nix repl` and `:lf .`
- Debug derivations: `nix develop --ignore-environment .#derivation.system`

- `nix-flake-lock-nixpkgs`
- `nix-vim-nixpkgs`

# Troubleshooting

- macOS update breaks environment

[See this bug](https://github.com/NixOS/nix/issues/3616)

Add

```
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
```

to `/etc/zshrc`

- macOS update breaks alacritty

Install using

```
brew install --cask alacritty --no-quarantine
```

to `/etc/zshrc`

Sometimes macOS decides you are not capable of your own decisions. Use:

```
xattr -rd com.apple.quarantine /Applications/Alacritty.app
```

- Alacritty not working properly

Update using brew.

# Open

- [ ] Neovim: Switch from FTerm to toggleterm
- [ ] Neovim: Switch to nixCats or similar to enable lazy loading + modular config
- [ ] Manix

- [ ] Get vaapi running on MacBookPro12,1 (chromium takes an incredible amount of cpu)
- [ ] Get Cirrus CS4208 running on MacBookPro12,1 (no bass)

- [ ] Clean up minimal / default includes

# Backlog

- [ ] Reenable newm, add newm-sidecar
