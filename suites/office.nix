{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    libreoffice-qt
    zoom-us
    obs-studio
    firefox
    cifs-utils
  ];

  services = {
    onedrive.enable = true;
    teamviewer.enable = true;

    printing = {
      enable = true;
      drivers = [ pkgs.canon-cups-ufr2 ];
    };
  };
}
