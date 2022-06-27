{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Tools
    gh # Github CLI
    docker
    docker-compose
    nixos-generators
    influxdb
    direnv
    nix-direnv

    # IDE
    jetbrains.clion
  ];

  # nix options for derivations to persist garbage collection
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';
  environment.pathsToLink = [
    "/share/nix-direnv"
  ];

  # Support flakes in nix-direnv
  nixpkgs.overlays = [
    (self: super: { nix-direnv = super.nix-direnv.override { enableFlakes = true; }; } )
  ];

  # Virtualization
  virtualisation.vmware.host.enable = true;

  # Add udev for MCC DAQ
  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="09db", ATTRS{idProduct}=="*", GROUP="users", MODE="0660"
  '';

  # Need this to build for Raspberry Pi aarch64
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
