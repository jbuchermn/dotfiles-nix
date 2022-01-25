{
  description = "jbuchermn system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    newmpkg.url = "github:jbuchermn/newm/v0.3";
    newmpkg.inputs.nixpkgs.follows = "nixpkgs";

    pywm-fullscreenpkg.url = "github:jbuchermn/pywm-fullscreen";
    pywm-fullscreenpkg.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, nur, home-manager, newmpkg, pywm-fullscreenpkg, ... }:
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
            (self: super: {
              newm = newmpkg.packages.${system}.newm;
              pywm-fullscreen = pywm-fullscreenpkg.packages.${system}.pywm-fullscreen; 
            })
          ];
        };

        lib = nixpkgs.lib;
      in
      {
        nixosConfigurations = {
          jb-nixos = lib.nixosSystem {
            inherit system;
            modules = [ ./system/jb-nixos/configuration.nix ];
          }; 

          jb-nixos-tuxedo = lib.nixosSystem {
            inherit system;
            modules = [ ./system/jb-nixos-tuxedo/configuration.nix ];
          }; 

          jb-nixos-qemu = lib.nixosSystem {
            inherit system;
            modules = [ ./system/jb-nixos-qemu/configuration.nix ];
          }; 

          jb-nixos-live = lib.nixosSystem {
            inherit system pkgs;
            modules = [
              ./system/jb-nixos-live/configuration.nix
              "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
              home-manager.nixosModules.home-manager

              ({ config, pkgs, ... }: {
                home-manager.users.nixos = {
                  fonts.fontconfig.enable = lib.mkForce true; # Specified as false somewhere in installation-cd-base

                  imports = [
                    ./users/jonas/home.nix
                  ];

                  home.stateVersion = stateVersion;
                  home.username = "nixos";
                  home.homeDirectory = "/home/nixos";
                };

                home-manager.useGlobalPkgs = true;

                home-manager.extraSpecialArgs = {
                  isMBP = false;
                };

                users.users.nixos.shell = pkgs.zsh;
              })
            ];
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
            };
          };

          jonas-nixos-tuxedo = home-manager.lib.homeManagerConfiguration {
            inherit system pkgs stateVersion;

            username = "jonas";
            homeDirectory = "/home/jonas";

            configuration = {
              imports = [
                ./users/jonas/home.nix
              ];
            };

            extraSpecialArgs = {
              isMBP = false;
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
              isWork = true;
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
              providePkgs = false;
            };
          };
        };
      }
    ) {"x86_64-linux" = 1; "x86_64-darwin" = 1; };
  };
}
