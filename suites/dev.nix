{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Tools
    nixos-generators
    pinentry-gtk2
    docker-compose
    config.boot.kernelPackages.perf
    virt-manager
    nix-alien

    # IDEs

    # Networking
    wireshark
  ];

  programs.nix-ld.enable = true;

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
    sandbox = relaxed
  '';

  environment.pathsToLink = [
    "/share/nix-direnv"
  ];

  # Virtualization
  virtualisation.vmware.host = {
    enable = true;
    package = pkgs.vmware-workstation;
  };

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  virtualisation.docker.enable = true;

  programs.adb.enable = true;
  services.udev.packages = [ pkgs.android-udev-rules ];

  # Add udev for MCC DAQ
  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="09db", ATTRS{idProduct}=="*", GROUP="users", MODE="0660"
  '';

  # Emulate buildsystems
  boot.binfmt.emulatedSystems = [ "aarch64-linux" "x86_64-windows" ];
}
