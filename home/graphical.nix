{ pkgs, ... }:
{
  home.packages = with pkgs; [
    brave

    master.jetbrains.clion
    master.jetbrains.pycharm-community
    master.android-studio

    # Note taking
    obsidian
  ];
}
