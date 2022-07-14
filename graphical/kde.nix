{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    desktopManager.plasma5.enable = true;
    displayManager.sddm = {
      enable = true;
      #theme = "${(pkgs.fetchFromGitHub {
      #  owner = "Kangie";
      #  repo = "sddm-sugar-candy";
      #  rev = "a1fae5159c8f7e44f0d8de124b14bae583edb5b8";
      #  sha256 = "17pkxpk4lfgm14yfwg6rw6zrkdpxilzv90s48s2hsicgl3vmyr3x";
      #})}";
    };
  };

  environment.systemPackages = with pkgs; [
    nordic
    tela-icon-theme
    sddm-kcm
    libsForQt5.bismuth
  ];
}
