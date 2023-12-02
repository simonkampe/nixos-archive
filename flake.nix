{
  description = "Structured configuration database";

  inputs = {
    # System
    nixpkgs.follows = "stable";

    # Extra channels
    stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    master.url = "github:NixOS/nixpkgs/master";
    extras.url = "github:simonkampe/nixpkgs/extras";

    # Utilities
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    nix-alien,
    ...
  }:
  let
    inherit (builtins) attrValues;
  in
  {
    overlays = [
      (final: prev: {
        stable = import inputs.stable {
          system = final.system;
          config.allowUnfree = true;
        };

        unstable = import inputs.unstable {
          system = final.system;
          config.allowUnfree = true;
        };

        master = import inputs.master {
          system = final.system;
          config.allowUnfree = true;
          config.permittedInsecurePackages = [ "snapmaker-luban-4.9.1" ];
        };

        extras = import inputs.extras {
          system = final.system;
          config.allowUnfree = true;
        };

        nix-alien = inputs.nix-alien.packages.${final.system}.nix-alien;
      })
    ];

    nixosConfigurations = {
      feynmann = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        pkgs = (import inputs.stable) {
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
          };
          overlays = self.overlays;
        } // { outPath = inputs.stable.outPath; };

        modules = [
          # Host
          hosts/feynmann.nix

          # DE/WM
          #hyprland.nixosModules.default
          #graphical/hyprland.nix
          graphical/kde.nix

          # Users
          users/simon.nix

          # Software
          common/common.nix
          common/locale.nix
          suites/common.nix
          suites/dev.nix
          suites/multimedia.nix
          suites/office.nix
          suites/social.nix
          suites/making.nix
          suites/antivirus.nix
          suites/linetic.nix
          suites/gaming.nix

          # Hardware
          #nixos-hardware.nixosModules.lenovo-thinkpad-p1-gen3
          nixos-hardware.nixosModules.common-cpu-intel
          hardware/tp1g3.nix
          #hardware/tlp.nix
        ];
      };

      mendelevium = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        pkgs = (import inputs.stable) {
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
          };
          overlays = self.overlays;
        };

        modules = [
          # Hardware
          nixos-hardware.nixosModules.common-gpu-nvidia
          nixos-hardware.nixosModules.common-cpu-intel
          
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
          suites/common.nix
          suites/dev.nix
          suites/multimedia.nix
          suites/office.nix
          suites/social.nix
          suites/making.nix
          suites/simra.nix
          suites/gaming.nix
        ];
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
          home/kde.nix

          home/graphical.nix

          home/simon.nix
          home/devtools.nix
          home/common.nix
          home/neovim.nix
          home/helix.nix
          home/office.nix
        ];
      };
    };
  };
}
