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

    # Need avahi for printers
    avahi = {
      enable = true;
      nssmdns = true;
    };

    printing = {
      enable = true;
      drivers = [ pkgs.canon-cups-ufr2 ];
    };
  };
}
