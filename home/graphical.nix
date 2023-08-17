{ pkgs, ... }:
{
  home.packages = with pkgs; [
    unstable.brave
    unstable.zoom-us

    unstable.jetbrains.clion
    unstable.jetbrains.pycharm-community
    #master.android-studio

    # Note taking
    unstable.obsidian
  ];
}
