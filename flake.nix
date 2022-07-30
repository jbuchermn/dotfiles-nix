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
  };

  outputs = { nixpkgs, flake-utils, nur, home-manager, newmpkg, pywm-fullscreenpkg, ... }:
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
          (self: super: {
            newm = newmpkg.packages.${system}.newm;
            pywm-fullscreen = pywm-fullscreenpkg.packages.${system}.pywm-fullscreen; 
          })
        ];
      };

      lib = nixpkgs.lib;

      nixosSystem = _modules: lib.nixosSystem {
          inherit system pkgs;
          modules = [ 
            ({ config, pkgs, ... }: {
              nix.registry.nixpkgs.flake = nixpkgs;
            })
          ] ++ _modules;
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
        jonas-nixos = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            ./users/jonas/home.nix
            {
              home = {
                username = "jonas";
                homeDirectory = "/home/jonas";
                stateVersion = stateVersion;
              };
            }
          ];
        };

        jonas-nixos-tuxedo = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs.legacyPackages.${system};

          modules = [
            ./users/jonas/home.nix
            {
              home = {
                username = "jonas";
                homeDirectory = "/home/jonas";
                stateVersion = stateVersion;
              };
            }
          ];


          extraSpecialArgs = {
            isMBP = false;
          };
        };

        jonas-nixos-virtual = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs.legacyPackages.${system};

          modules = [
            ./users/jonas/home.nix
            {
              home = {
                username = "jonas";
                homeDirectory = "/home/jonas";
                stateVersion = stateVersion;
              };
            }
          ];


          extraSpecialArgs = {
            isVirtual = true;
          };
        };

        jonas-mbp = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs.legacyPackages.${system};

          modules = [
            ./users/jonas-mbp/home.nix
            {
              home = {
                username = "jonas";
                homeDirectory = "/Users/jonas";
                stateVersion = stateVersion;
              };
            }
          ];


          extraSpecialArgs = {
            providePkgs = false;
            provideFont = false; # Some weird home-manager bug
          };
        };

        jonasmhp-mbp = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs.legacyPackages.${system};

          modules = [
            ./users/jonas-mbp/home.nix
            {
              home = {
                username = "jonas";
                homeDirectory = "/Users/jonasmhp";
                stateVersion = stateVersion;
              };
            }
          ];


          extraSpecialArgs = {
            isWork = true;
            providePkgs = false;
            provideFont = false; # Some weird home-manager bug
          };
        };

        jonas-mba = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs.legacyPackages.${system};

          modules = [
            ./users/jonas-mba/home.nix
            {
              home = {
                username = "jonas";
                homeDirectory = "/Users/jonas";
                stateVersion = stateVersion;
              };
            }
          ];


          extraSpecialArgs = {
            providePkgs = false;
          };
        };

        jonas = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs.legacyPackages.${system};

          modules = [
            ./users/jonas/home.nix
            {
              home = {
                username = "jonas";
                homeDirectory = "/home/jonas";
                stateVersion = stateVersion;
              };
            }
          ];


          extraSpecialArgs = {
            providePkgs = false;
          };
        };
      };
    }
  );
}
