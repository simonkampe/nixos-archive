{ pkgs, ... }:
{
  home.packages = with pkgs; [
    brave

    extras.jetbrains.clion

    # Note taking
    obsidian
  ];
}