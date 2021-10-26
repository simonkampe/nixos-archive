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
    pop-icon-theme

    # Utils
    pavucontrol
    brightnessctl
    glib # For gsettings

    # Wayland/X11 compatability
    xwayland
  ];

  programs = {
    ssh.startAgent = true;
  };
}
