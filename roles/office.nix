{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    mailspring
    libreoffice-qt
    evolution-desktop
    teams
  ];
}
