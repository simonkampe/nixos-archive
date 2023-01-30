{ pkgs, lib, ... }:

{
  services.xserver = {
    enable = true;
    desktopManager.plasma5.enable = true;
    displayManager.sddm = {
      enable = true;
      theme = "${(pkgs.fetchFromGitHub {
        owner = "Kangie";
        repo = "sddm-sugar-candy";
        rev = "a1fae5159c8f7e44f0d8de124b14bae583edb5b8";
        sha256 = "sha256-p2d7I0UBP63baW/q9MexYJQcqSmZ0L5rkwK3n66gmqM=";
      })}";
    };
  };

  # External monitor lag fix
  environment.sessionVariables = {
    KWIN_DRM_USE_MODIFIERS="0";
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
    libsForQt5.sddm-kcm
    plasma5Packages.plasma-thunderbolt
  ];

  programs.partition-manager.enable = true;
}
