{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    snapmaker-luban
    freecad
  ];
}
