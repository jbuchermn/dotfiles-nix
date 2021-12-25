# dotfiles

Update config

```bash
home-manager switch
```

## Vim

To see all available plugins

```bash
nix-env -f '<nixpkgs>' -qaP -A vimPlugins
```

ToDo:
[X] Fuzzy file navigation
[X] Proper LSP setup
[X] Keybindings
  - leader cd and similar for code
  - leader pf
  - leader op / - for NERDTREE
[X] Git like magit
- Orgmode replacement
