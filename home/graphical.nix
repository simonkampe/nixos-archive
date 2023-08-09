{ pkgs, ... }:
{
  home.packages = with pkgs; [
    unstable.brave

    unstable.jetbrains.clion
    unstable.jetbrains.pycharm-community
    #master.android-studio

    # Note taking
    unstable.obsidian
  ];
}
