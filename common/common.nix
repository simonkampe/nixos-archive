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
    avahi.enable = true;
    avahi.nssmdns = true;
  };
}

