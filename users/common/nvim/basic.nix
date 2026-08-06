{ inputs, pkgs, ... }:
let
  nvimBuilder = import ./mk-neovim.nix { inherit inputs pkgs; };
  categories = {
    basic = true;
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
