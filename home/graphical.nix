{ pkgs, ... }:
{
  home.packages = with pkgs; [
    unstable.brave
    unstable.zoom-us

    unstable.jetbrains.clion
    unstable.jetbrains.pycharm-professional
    unstable.jetbrains.webstorm
    unstable.jetbrains.rider
    unstable.jetbrains.rust-rover
    #master.android-studio

    # Note taking
    master.obsidian
  ];
}
