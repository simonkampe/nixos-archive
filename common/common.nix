# Sets all common options
{ pkgs, lib, config, inputs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # Enable NTFS support
  boot.supportedFilesystems = [ "ntfs" ];

  hardware.enableAllFirmware = true;

  nix = {
    nixPath = [ "nixpkgs=${pkgs.outPath}" ];

    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
    };
  };

  services = {
    fwupd.enable = true;
    resolved.enable = true;
    avahi = {
      enable = true;
      nssmdns = true;
      publish = {
        enable = false;
        addresses = true;
        domain = true;
        hinfo = true;
        userServices = true;
        workstation = true;
      };
    };
  };
}

