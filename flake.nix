{
  description = "Structured configuration database";

  #nixConfig.extra-experimental-features = "nix-command flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
    #nixpkgs-wayland = { url = "github:nix-community/nixpkgs-wayland"; };
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    simon.url = "github:simonkampe/nixpkgs/vmware-host-modules";

    #nixpkgs-wayland.inputs.nixpkgs.follows = "cmpkgs";
    #nixpkgs-wayland.inputs.master.follows = "master";
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
      #overlays = [ inputs.nixpkgs-wayland.overlay ] ++ attrValues self.overlays;
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
      simon = final: prev: {
        simon = import inputs.simon {
          system = final.system;
          config.allowUnfree = true;
        };
      };
    };

    nixosConfigurations.heimdall = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        hosts/heimdall.nix
        hardware/vmware.nix
        common/locale.nix
        graphical/kde.nix
      ];

      inherit pkgs;
    };
  };
}
