{
  description = "jbuchermn system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    nur.url = "github:nix-community/NUR";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nixCats.url = "github:BirdeeHub/nixCats-nvim";

  };

  outputs =
    inputs@{
      nixpkgs,
      flake-utils,
      nur,
      home-manager,
      nixos-generators,
      ...
    }:
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
            nur.overlays.default
          ];
        };

        nixosSystem =
          modules:
          nixpkgs.lib.nixosSystem {
            inherit system pkgs;
            modules = [
              {
                nix.registry.nixpkgs.flake = nixpkgs;
              }
            ]
            ++ modules;
          };

        homeManagerConfiguration =
          {
            modules,
            username,
            homeDirectory,
            extraSpecialArgs ? { },
          }:
          home-manager.lib.homeManagerConfiguration {
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
            ]
            ++ modules;

            extraSpecialArgs = extraSpecialArgs // {
              inherit inputs;
            };
          };
      in
      {
        packages.nixosConfigurations = {
          jb-nixos = nixosSystem [
            ./system/jb-nixos/configuration.nix
            # nixos-hardware.nixosModules.apple-macbook-pro-12-1
          ];

          jb-nixos-tuxedo = nixosSystem [
            ./system/jb-nixos-tuxedo/configuration.nix
          ];

          jb-nixos-qemu = nixosSystem [
            ./system/jb-nixos-qemu/configuration.nix
          ];

          jb-nixos-live = nixosSystem [
            nixos-generators.nixosModules.all-formats
            home-manager.nixosModules.home-manager

            ./system/jb-nixos-live/configuration.nix

            (
              { config, pkgs, ... }:
              {
                home-manager = {
                  users.jonas = {
                    imports = [
                      ./users/jonas-live/home.nix
                    ];

                    home = {
                      inherit stateVersion;
                      username = "jonas";
                      homeDirectory = "/home/jonas";
                    };
                  };

                  useGlobalPkgs = true;

                  extraSpecialArgs = {
                    isMBP = false;
                  };
                };
              }
            )
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
            username = "jbucher2";
            homeDirectory = "/Users/jbucher2";

            modules = [
              ./users/jonas-mbp/home.nix
            ];

            extraSpecialArgs = {
              isWork = true;
              providePkgs = false;
              extraEnv = ''
                export MHP="/Users/jbucher2/Library/CloudStorage/OneDrive-mhp-group.com/Documents/MHP"
              '';
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
