{ pkgs, ... }:
{
  home.packages = with pkgs; [
    unstable.brave
    unstable.zoom-us

    unstable.jetbrains.clion
    unstable.jetbrains.pycharm-professional
    unstable.jetbrains.webstorm
    #master.android-studio

    # Note taking
    unstable.obsidian
  ];
}
