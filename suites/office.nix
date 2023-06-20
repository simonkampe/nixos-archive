{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    libreoffice
    obs-studio
    cifs-utils
    samba
    remmina # RDP client
    teamviewer
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
