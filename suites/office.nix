{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kmail
    libreoffice-qt
    teams
    zoom-us
    obs-studio
  ];

  # Needed for mailspring
  services.gnome.gnome-keyring.enable = true;

  services = {
    onedrive.enable = true;
  };
}
