{
  description = "Structured configuration database";

  nixConfig.extra-experimental-features = "nix-command flakes";

  inputs = {
    # System
    nixpkgs.follows = "stable";
    stable.url = "github:NixOS/nixpkgs/nixos-22.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    master.url = "github:NixOS/nixpkgs/master";
    hyprland.url = "github:hyprwm/Hyprland";
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
    hyprland,
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

      (final: prev: {
        waybar = prev.waybar.overrideAttrs (old: {
          patchPhase = ''
            sed -i 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
          '';
          mesonFlags = old.mesonFlags ++ [ "-Dexperimental=true" ];
        });
      })
    ];

    nixosConfigurations = {
      feynmann = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        pkgs = (import inputs.unstable) {
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
          };
          overlays = self.overlays;
        };

        modules = [
          # Host
          hosts/feynmann.nix
          hosts/feynmann-secrets.nix

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
          suites/linetic.nix

          # Hardware
          #nixos-hardware.nixosModules.lenovo-thinkpad-p1-gen3
          nixos-hardware.nixosModules.common-cpu-intel
          hardware/tp1g3.nix
          hardware/tlp.nix
        ];
      };

      mendelevium = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        pkgs = (import inputs.unstable) {
          system = "x86_64-linux";
          config.allowUnfree = true;
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
        ];
      };
    };
  };
}
