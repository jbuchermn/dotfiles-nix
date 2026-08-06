{ inputs, pkgs, ... }:
let
  nvimBuilder = import ./mk-neovim.nix { inherit inputs pkgs; };
  categories = {
    basic = true;
    extended = true;
    lua = true;
    nix = true;
    typescript = true;
    markdown = true;
    python = true;
    haskell = true;
    c = true;
  };

in
{
  imports = [ inputs.nixCats.homeModule ];

  config = nvimBuilder.mkNeovimConfig {
    packageName = "home-neovim";
    enabledCategories = categories;
    aliases = [ "vim" ];
  };
}
