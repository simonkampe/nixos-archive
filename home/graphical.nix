{ pkgs, ... }:
{
  home.packages = with pkgs; [
    brave
    master.jetbrains.clion
  ];
}
