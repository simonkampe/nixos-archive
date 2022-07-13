{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    silver-searcher
    killall
    parted
    wget
    curl
    htop
    git

    # Editors
    helix
    (unstable.neovim.override {
      viAlias = true;
      vimAlias = true;
    })
  ];
}
