{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wpsoffice
    zoom-us
    obs-studio
    cifs-utils
    samba
    remmina # RDP client
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
