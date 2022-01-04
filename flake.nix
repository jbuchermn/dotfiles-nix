{
  description = "jbuchermn system config";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:jbuchermn/nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    stateVersion = "22.05";
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
      jonas-virtual = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs stateVersion;

        username = "jonas";
        homeDirectory = "/home/jonas";

        configuration = {
          imports = [
            ./users/jonas/home.nix
          ];
        };

        extraSpecialArgs = {
          virtual-machine = true;
        };
      };

      jonas = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs stateVersion;

        username = "jonas";
        homeDirectory = "/home/jonas";

        configuration = {
          imports = [
            ./users/jonas/home.nix
          ];
        };

        extraSpecialArgs = {
          virtual-machine = false;
        };
      };
    };
  };
}
