{
  description = "Structured configuration database";

  nixConfig.extra-experimental-features = "nix-command flakes";

  inputs = {
    # System
    nixpkgs.follows = "stable";
    stable.url = "github:NixOS/nixpkgs/nixos-22.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    master.url = "github:NixOS/nixpkgs/master";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nixos-hardware,
    home-manager,
    ...
  }:
  let
    inherit (builtins) attrValues;
    pkgs = (import inputs.nixpkgs) {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;

        # Temporarily allowed unsecure packages
        permittedInsecurePackages = [
          #"qtwebkit-5.212.0-alpha4"
        ];

      };
      overlays = self.overlays;
    };
  in
  {
    overlays = [
      (final: prev: {
        stable = import inputs.stable {
          system = final.system;
          config.allowUnfree = true;
        };
      })
      (final: prev: {
        unstable = import inputs.unstable {
          system = final.system;
          config.allowUnfree = true;
        };
      })
      (final: prev: {
        master = import inputs.master {
          system = final.system;
          config.allowUnfree = true;
        };
      })
      (final: prev: {
        fork = import inputs.fork {
          system = final.system;
          config.allowUnfree = true;
        };
      })
      #(final: prev: {
      #  vmware-modules = prev.vmware-modules.overrideAttrs(_: {
      #  
      #  });
      #})
      (final: prev: {
        /*
        jetbrains.jdk = prev.jetbrains.jdk.overrideAttrs (_: rec {
          version = "17.0.5-b653.23";
          src = prev.fetchFromGitHub {
            owner = "JetBrains";
            repo = "JetBrainsRuntime";
            rev = "jb${version}";
            hash = "sha256-7Nx7Y12oMfs4zeQMSfnUaDCW1xJYMEkcoTapSpmVCfU=";
          };
        });
        jetbrains.clion = prev.jetbrains.clion.overrideAttrs (_: rec {
          version = "2022.3.1";
          src = prev.fetchurl {
            url = "https://download.jetbrains.com/cpp/CLion-2022.3.1.tar.gz";
            sha256 = "cd057a0aa96cf5b4216a436136a1002e6f3dc578bcd8a69f98d6908381b03526";
          };
        });
        jetbrains.idea-community = prev.jetbrains.idea-community.overrideAttrs (_: rec {
          version = "2022.3.1";
          src = prev.fetchurl {
            url = "https://download.jetbrains.com/idea/ideaIC-2022.3.1.tar.gz";
            sha256 = "4c3514642ce6c86e5343cc29b01c06ddc9c55f134bcb6650de5d7d36205799e8";
          };
        });
        jetbrains.pycharm-community = prev.jetbrains.pycharm-community.overrideAttrs (_: rec {
          version = "2022.3.1";
          src = prev.fetchurl {
            url = "https://download.jetbrains.com/python/pycharm-community-2022.3.1.tar.gz";
            sha256 = "b243103f27cfb763106a2f5667d8f201562154755ce9746e81e88c80acd7b316";
          };
          });
          */
      })
    ];

    nixosConfigurations = {
      feynmann = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        pkgs = (import inputs.stable) {
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
            #allowBroken = true;
          };
          overlays = self.overlays ++ [
            (final: prev: {
               /*
              linuxPackages_latest = prev.linuxPackages_latest.extend (linux_final: linux_prev: {
                evdi = linux_prev.evdi.overrideAttrs (evdi_final: evdi_prev: {
                  version = "1.12.0-git";
                  src = prev.fetchFromGitHub {
                    owner = "DisplayLink";
                    repo = "evdi";
                    rev = "bdc258b25df4d00f222fde0e3c5003bf88ef17b5";
                    sha256 = "sha256-7Nx7Y12oMfs4zeQMSfnUaDCW1xJYMEkcoTapSpmVCfU=";
                  };
                });
              });

              displaylink = prev.displaylink.override { inherit (final.linuxPackages_latest) evdi; };
              */
            })
          ];
        };

        modules = [
          # Host
          hosts/feynmann.nix
          hosts/feynmann-secrets.nix

          # DE/WM
          #graphical/sway.nix
          graphical/kde.nix

          # Users
          users/simon.nix

          # Software
          common/common.nix
          common/locale.nix
          suites/common_utils.nix
          suites/dev.nix
          suites/multimedia.nix
          suites/office.nix
          suites/social.nix
          suites/making.nix
          suites/linetic.nix

          # Hardware
          hardware/tp1g3.nix
          nixos-hardware.nixosModules.lenovo-thinkpad-p1-gen3
        ];
      };

      mendelevium = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        pkgs = (import inputs.stable) {
          system = "x86_64-linux";
          config.allowUnfree = true;
          overlays = self.overlays;
        };

        modules = [
          # Host
          hosts/mendelevium.nix

	  # DE/WM
          #graphical/sway.nix
          graphical/kde.nix

          # Users
          users/simon.nix

          # Software
          common/common.nix
          common/locale.nix
          suites/common_utils.nix
          suites/dev.nix
          suites/multimedia.nix
          suites/office.nix
          suites/social.nix
          suites/making.nix
          suites/simra.nix
          suites/gaming.nix

          # Hardware
          nixos-hardware.nixosModules.common-gpu-nvidia
          nixos-hardware.nixosModules.common-cpu-intel
        ];
      };

      marie = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
	  # DE/WM
          #graphical/sway.nix
          graphical/kde.nix

          # Users
          users/simon.nix

          # Software
          hosts/marie.nix
          common/common.nix
          common/locale.nix
          suites/common_utils.nix

          # Hardware
          nixos-hardware.nixosModules.common-cpu-intel
        ];

        inherit pkgs;
      };
    };

    homeConfigurations = {
      simon = home-manager.lib.homeManagerConfiguration {
        pkgs = (import inputs.unstable) {
          system = "x86_64-linux";
          config.allowUnfree = true;
          overlays = self.overlays;
        };

        modules = [
          inputs.plasma-manager.homeManagerModules.plasma-manager
          home/simon.nix
          home/devtools.nix
          home/common.nix
          home/neovim.nix
          home/helix.nix
          home/kde.nix
        ];
      };
    };
  };
}
