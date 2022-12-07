{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wpsoffice
    zoom-us
    obs-studio
    firefox
    cifs-utils
    samba
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
