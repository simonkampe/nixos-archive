{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Tools
    nixos-generators
    pinentry-gtk2
    docker-compose
  ];

  # Enable gpg
  services.pcscd.enable = true;
  programs.gnupg.agent = {
     enable = true;
     pinentryFlavor = "gtk2";
     enableSSHSupport = true;
  };

  # nix options for derivations to persist garbage collection
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';
  environment.pathsToLink = [
    "/share/nix-direnv"
  ];

  # Virtualization
  virtualisation.vmware.host = {
    enable = true;
    package = pkgs.unstable.vmware-workstation;
  };

  virtualisation.docker.enable = true;

  # Add udev for MCC DAQ
  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="09db", ATTRS{idProduct}=="*", GROUP="users", MODE="0660"
  '';

  # Need this to build for Raspberry Pi aarch64
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
