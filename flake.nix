{
  description = "jbuchermn system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    newm-pkg.url = "github:jbuchermn/newm/4686f5d";
    newm-pkg.inputs.nixpkgs.follows = "nixpkgs";

    # newm-pkg.url = "path:/home/jonas/newm-dev/pywm";
    # newm-pkg.inputs.pywm.url = "path:/home/jonas/newm-dev/newm";
  };

  outputs = { nixpkgs, nur, home-manager, newm-pkg, ... }:
  let
    system = "x86_64-linux";
    stateVersion = "22.05";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
      overlays = [
        nur.overlay
        (final: prev: { newm = newm-pkg.packages.${system}.newm; })
      ];
    };
    lib = nixpkgs.lib;
  in
  {
    nixosConfigurations = {
      jb-nixos-qemu = lib.nixosSystem {
        inherit system;
        modules = [ ./system/jb-nixos-qemu/configuration.nix ];
      }; 

      jb-nixos = lib.nixosSystem {
        inherit system;
        modules = [ ./system/jb-nixos/configuration.nix ];
      }; 
    }; 

    homeManagerConfigurations = {
      jonas-nixos = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs stateVersion;

        username = "jonas";
        homeDirectory = "/home/jonas";

        configuration = {
          imports = [
            ./users/jonas/home.nix
          ];
        };

        extraSpecialArgs = {
          isVirtual = false;
          providePkgs = true;
        };
      };

      jonas-nixos-virtual = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs stateVersion;

        username = "jonas";
        homeDirectory = "/home/jonas";

        configuration = {
          imports = [
            ./users/jonas/home.nix
          ];
        };

        extraSpecialArgs = {
          isVirtual = true;
          providePkgs = true;
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
          isVirtual = false;
          providePkgs = false;
        };
      };
    };
  };
}
