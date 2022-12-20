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
      #(final: prev: {
      #  jetbrains.jdk = prev.jetbrains.jdk;
      #  jetbrains.clion = prev.jetbrains.clion.overrideAttrs (_: rec {
      #    src = prev.fetchurl {
      #      url = "https://download.jetbrains.com/cpp/CLion-2022.2.tar.gz";
      #      sha256 = "sha256-lP+9+CYG8vkGGMH9uJQy1ifn8krhWLNqWR2iwwMEdDY=";
      #    };
      #  });
      #})
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
          overlays = self.overlays;
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
