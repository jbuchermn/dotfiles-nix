{
  description = "jbuchermn system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    newmpkg.url = "github:jbuchermn/newm";
    newmpkg.inputs.nixpkgs.follows = "nixpkgs";

    pywm-fullscreenpkg.url = "github:jbuchermn/pywm-fullscreen";
    pywm-fullscreenpkg.inputs.nixpkgs.follows = "nixpkgs";

    guacamolepkg.url = "github:jbuchermn/guacamole-nixos";
    guacamolepkg.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, flake-utils, nur, home-manager, newmpkg, pywm-fullscreenpkg, guacamolepkg, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        stateVersion = "22.05";

        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
          overlays = [
            nur.overlay
            (self: super: { }
              // newmpkg.packages.${system}
              // pywm-fullscreenpkg.packages.${system}
              // guacamolepkg.packages.${system})
          ];
        };

        lib = nixpkgs.lib;

        nixosSystem = modules: lib.nixosSystem {
          inherit system pkgs;
          modules = [
            ({ config, pkgs, ... }: {
              nix.registry.nixpkgs.flake = nixpkgs;
            })
            guacamolepkg.nixosModules.${system}.guacamole
          ] ++ modules;
        };

        homeManagerConfiguration = { modules, username, homeDirectory, extraSpecialArgs ? { } }: home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            {
              nix.registry.nixpkgs.flake = nixpkgs;
            }
            {
              home = {
                inherit username homeDirectory stateVersion;
              };
            }
          ] ++ modules;

          inherit extraSpecialArgs;
        };
      in
      {
        packages.nixosConfigurations = {
          jb-nixos = nixosSystem [
            ./system/jb-nixos/configuration.nix
          ];

          jb-nixos-tuxedo = nixosSystem [
            ./system/jb-nixos-tuxedo/configuration.nix
          ];

          jb-nixos-qemu = nixosSystem [
            ./system/jb-nixos-qemu/configuration.nix
          ];

          jb-nixos-live = nixosSystem [
            ./system/jb-nixos-live/configuration.nix
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
            home-manager.nixosModules.home-manager

            ({ config, pkgs, ... }: {
              fonts.fontconfig.enable = lib.mkForce true; # Specified as false somewhere in installation-cd-base
              home-manager = {
                users.nixos = {
                  imports = [
                    ./users/nixos/home.nix
                  ];

                  home = {
                    stateVersion = stateVersion;
                    username = "nixos";
                    homeDirectory = "/home/nixos";
                  };
                };

                useGlobalPkgs = true;

                extraSpecialArgs = {
                  isMBP = false;
                };
              };

              users.users.nixos.shell = pkgs.zsh;
            })
          ];
        };

        packages.homeManagerConfigurations = {
          jonas-nixos = homeManagerConfiguration {
            username = "jonas";
            homeDirectory = "/home/jonas";

            modules = [
              ./users/jonas/home.nix
            ];
          };

          jonas-nixos-tuxedo = homeManagerConfiguration {
            username = "jonas";
            homeDirectory = "/home/jonas";

            modules = [
              ./users/jonas/home.nix
            ];

            extraSpecialArgs = {
              isMBP = false;
            };
          };

          jonas-nixos-virtual = homeManagerConfiguration {
            username = "jonas";
            homeDirectory = "/home/jonas";

            modules = [
              ./users/jonas/home.nix
            ];

            extraSpecialArgs = {
              isVirtual = true;
            };
          };

          jonas-mbp = homeManagerConfiguration {
            username = "jonas";
            homeDirectory = "/Users/jonas";

            modules = [
              ./users/jonas-mbp/home.nix
            ];

            extraSpecialArgs = {
              providePkgs = false;
            };
          };

          jonasmhp-mbp = homeManagerConfiguration {
            username = "jonas";
            homeDirectory = "/Users/jonasmhp";

            modules = [
              ./users/jonas-mbp/home.nix
            ];

            extraSpecialArgs = {
              isWork = true;
              providePkgs = false;
            };
          };

          jonas-mba = homeManagerConfiguration {
            username = "jonas";
            homeDirectory = "/Users/jonas";

            modules = [
              ./users/jonas-mba/home.nix
            ];

            extraSpecialArgs = {
              providePkgs = false;
            };
          };

          jonas = homeManagerConfiguration {
            username = "jonas";
            homeDirectory = "/home/jonas";

            modules = [
              ./users/jonas/home.nix
            ];

            extraSpecialArgs = {
              providePkgs = false;
            };
          };
        };
      }
    );
}
