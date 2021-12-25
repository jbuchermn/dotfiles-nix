# dotfiles

Update config

```bash
home-manager switch
```

## Vim

To see all available plugins

```
nix-env -f '<nixpkgs>' -qaP -A vimPlugins
```

ToDo:
- Fuzzy file navigation
- Proper LSP setup
- Keybindings
  - leader cd and similar for code
  - leader pf
  - leader op / - for NERDTREE
- Git like magit
- Orgmode replacement
