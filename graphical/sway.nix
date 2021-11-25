{ pkgs, ... }:

{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      mako # Notifications
      wofi # Launcher
      waybar
      kanshi # arandr replacement
      libnotify
    ];
  };

  environment.systemPackages = with pkgs; [
    # DE
    wl-clipboard
    xfce.thunar
    xfce.thunar-volman
    xfce.xfconf # To save preferences
    xfce.tumbler # For thumbnails
    arc-icon-theme
    udiskie
    gnome.networkmanagerapplet
    gnome.gnome-keyring

    # Utils
    pavucontrol
    brightnessctl
    glib # For gsettings

    # Wayland/X11 compatability
    xwayland
  ];

  programs = {
    ssh.startAgent = true;
    seahorse.enable = true;
  };

  services = {
    gvfs.enable = true;
    udisks2.enable = true;
    gnome = {
      gnome-keyring.enable = true;
      at-spi2-core.enable = true;
    };
  };
}
