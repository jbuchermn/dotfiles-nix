{
  description = "jbuchermn system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # newm-pkg.url = "github:jbuchermn/newm";
    newm-pkg.url = "github:jbuchermn/newm/v0.3";
    newm-pkg.inputs.nixpkgs.follows = "nixpkgs";

    # newm-pkg.url = "path:/home/jonas/newm-dev/newm";
    # newm-pkg.inputs.pywm.url = "path:/home/jonas/newm-dev/pywm";
  };

  outputs = { nixpkgs, nur, home-manager, newm-pkg, ... }:
  {
    packages = builtins.mapAttrs (system: _:
      let
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

          jonas-mbp = home-manager.lib.homeManagerConfiguration {
            inherit pkgs system stateVersion;

            username = "jonas";
            homeDirectory = "/Users/jonas";

            configuration = {
              imports = [
                ./users/jonas-mbp/home.nix
              ];
            };

            extraSpecialArgs = {
              isMHP = false;
              isVirtual = false;
              providePkgs = false;
            };
          };

          jonasmhp-mbp = home-manager.lib.homeManagerConfiguration {
            inherit pkgs system stateVersion;

            username = "jonas";
            homeDirectory = "/Users/jonas";

            configuration = {
              imports = [
                ./users/jonas-mbp/home.nix
              ];
            };

            extraSpecialArgs = {
              isMHP = true;
              isVirtual = false;
              providePkgs = false;
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
      }
    ) {"x86_64-linux" = 1; "x86_64-darwin" = 1; };
  };
}
