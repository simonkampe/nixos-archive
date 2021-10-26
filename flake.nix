{
  description = "Structured configuration database";

  nixConfig.extra-experimental-features = "nix-command flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{
    self,
    nixpkgs,
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

    nixosConfigurations.heimdall = nixpkgs.lib.nixosSystem {
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
  };
}
