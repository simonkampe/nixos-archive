{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Utilities
    silver-searcher
    killall
    parted
    wget
    curl
    htop
    git
    unzip
    imagemagick
    glxinfo
    p7zip
    pciutils
    usbutils
  ];
}
