{
  description = "Structured configuration database";

  nixConfig.extra-experimental-features = "nix-command flakes";

  inputs = {
    # System
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
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
    pkgs = (import nixpkgs) {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
      };
      overlays = attrValues self.overlays;
    };
  in
  {
    overlays = {
      unstable = final: prev: {
        unstable = import inputs.unstable {
          system = final.system;
          config.allowUnfree = true;
        };
      };
    };

    nixosConfigurations = {
      feynmann = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          # DE/WM
          #graphical/sway.nix
          graphical/kde.nix

          # Users
          users/simon.nix

          # Software
          hosts/feynmann.nix
          common/common.nix
          common/locale.nix
          suites/common_utils.nix
          suites/dev.nix
          suites/multimedia.nix
          suites/office.nix
          suites/social.nix

          # Hardware
          hosts/feynmann/hardware-configuration.nix
          hardware/tp1g3.nix
          nixos-hardware.nixosModules.lenovo-thinkpad-p1-gen3
          nixos-hardware.nixosModules.common-gpu-nvidia
          nixos-hardware.nixosModules.common-cpu-intel
        ];

        inherit pkgs;
      };

      mendelevium = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          hosts/mendelevium.nix
          hosts/mendelevium-hardware-configuration.nix
          common/locale.nix
          graphical/kde.nix
        ];

        inherit pkgs;
      };
    };

    homeConfigurations = {
      simon = home-manager.lib.homeManagerConfiguration {
        modules = [
          inputs.plasma-manager.homeManagerModules.plasma-manager
          home/simon.nix
          home/common.nix
          home/kde.nix
        ];

        inherit pkgs;
      };
    };
  };
}
