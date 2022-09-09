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
    libsForQt5.kio-gdrive
    libsForQt5.kaccounts-providers
    libsForQt5.kaccounts-integration
    libsForQt5.filelight
    libsForQt5.ark
    libsForQt5.kalk
    libsForQt5.kate
    partition-manager
  ];
}
