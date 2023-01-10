# Sets all common options
{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # Enable NTFS support
  boot.supportedFilesystems = [ "ntfs" ];

  hardware.enableAllFirmware = true;

  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
    };
  };

  services = {
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

