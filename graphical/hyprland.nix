{ lib, pkgs, config, ... }:
{
  programs.hyprland.enable = true;

  services.xserver = {
    enable = true;

    desktopManager.xterm.enable = false;

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

  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  fonts.fonts = with pkgs; [
  ];

  programs.dconf.enable = true;

  networking.networkmanager.enable = true;

  # USB auto mount
  services.udisks2.enable = true;

  # Samba etc.
  services.gvfs.enable = true;

  environment.systemPackages = with pkgs; [
    waybar # Bar
    wofi # Launcher

    # File manager
    xfce.thunar
    xfce.thunar-volman

    pavucontrol # Sound settings
    pulseaudio # For pactl

    networkmanagerapplet # Network

    brightnessctl # Backlight

    # SDDM
    libsForQt5.qt5.qtgraphicaleffects
  ];
}
