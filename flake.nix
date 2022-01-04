{
  description = "jbuchermn system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
    lib = nixpkgs.lib;
  in
  {
    nixosConfigurations = {
      jb-nixos-qemu = lib.nixosSystem {
        inherit system;
        modules = [ ./system/jb-nixos-qemu/configuration.nix ];
      }; 
    }; 

    homeManagerConfigurations = {
      jonas = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs;

        username = "jonas";
        homeDirectory = "/home/jonas";
        stateVersion = "22.05";

        configuration = {
          imports = [
            ./users/jonas/home.nix
          ];
        };
      };
    };
  };
}
