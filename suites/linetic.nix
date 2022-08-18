{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kmail
    teams
  ];
}

