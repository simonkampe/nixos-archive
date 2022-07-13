{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    mailspring
    libreoffice-qt
    teams
  ];

  # Needed for mailspring
  services.gnome.gnome-keyring.enable = true;
}
