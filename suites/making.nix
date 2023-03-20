{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    snapmaker-luban
    blender
    freecad
    gimp
    inkscape
  ];
}
