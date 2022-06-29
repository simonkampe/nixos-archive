{
  description = "Structured configuration database";

  nixConfig.extra-experimental-features = "nix-command flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nixos-hardware,
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
          # Software
          hosts/feynmann.nix
          common/common.nix
          common/locale.nix
          roles/common_utils.nix
          roles/dev.nix
          roles/multimedia.nix
          roles/office.nix

          # Hardware
          hosts/feynmann/hardware-configuration.nix
          hardware/tp1g3.nix
          nixos-hardware.nixosModules.lenovo-thinkpad-p1-gen3
          nixos-hardware.nixosModules.common-gpu-nvidia
          nixos-hardware.nixosModules.common-cpu-intel
        ];

        inherit pkgs;
      };

      heimdall = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          hosts/heimdall.nix
          hosts/heimdall/hardware-configuration.nix
          common/locale.nix
          hardware/tp1g3.nix
          graphical/sway.nix
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
  };
}
