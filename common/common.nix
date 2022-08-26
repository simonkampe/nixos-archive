# Sets all common options
{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # Enable NTFS support
  boot.supportedFilesystems = [ "ntfs" ];

  hardware.enableAllFirmware = true;

  #nix = {
  #  package = pkgs.nixFlakes;
  #  extraOptions = ''
  #    experimental-features = nix-command flakes";
  #  '';
  #};

  services = {
    resolved.enable = true;
    avahi = {
      enable = true;
      nssmdns = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        hinfo = true;
        userServices = true;
        workstation = true;
      };
    };
  };
}

