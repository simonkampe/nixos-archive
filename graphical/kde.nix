{ pkgs, lib, ... }:

{
  services.xserver = {
    enable = true;
    desktopManager.plasma5.enable = true;
    displayManager.sddm.enable = true;
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
