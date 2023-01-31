{ lib, pkgs, config, ... }:
let
  schema = pkgs.gsettings-desktop-schemas;
  datadir = "${schema}/share/gsettings-schemas/${schema.name}";

  configure-gtk = pkgs.writeTextFile {
      name = "configure-gtk";
      destination = "/bin/configure-gtk";
      executable = true;
      text = ''
        export XDG_DATA_DIRS="${datadir}:$XDG_DATA_DIRS";
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Catppuccin'
        gsettings set $gnome_schema icon-theme 'Arc'
        gsettings set $gnome_schema cursor-theme 'Qogir'
        gsettings set $gnome_schema cursor-size '24'
        gsettings set $gnome_schema font-name 'Noto'
      '';
  };

  hypr = pkgs.writeTextFile {
    name = "hypr";
    destination = "/bin/hypr";
    executable = true;
    text = ''
      #!/usr/bin/env sh

      export XDG_DATA_DIRS="${datadir}:$XDG_DATA_DIRS";

      exec Hyprland
    '';
  };
in {
  programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };
  };

  services.xserver = {
    enable = true;
    synaptics.enable = true;
    desktopManager.xterm.enable = false;
    displayManager.startx.enable = true;
  };

  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  # Bluetooth
  services.blueman.enable = true;

  # USB auto mount
  services.udisks2.enable = true;

  # Samba etc.
  services.gvfs.enable = true;

  # Allow swaylock to PAM
  security.pam.services.swaylock = {};

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1"; # Fix disappearing cursor
    XWAYLAND_NO_GLAMOR = "1";
    XDG_CURRENT_DESKTOP = "Unity"; # As waybar requests it for tray
  };

  fonts.fonts = with pkgs; [
    noto-fonts
  ];

  environment.systemPackages = with pkgs; [
    hypr # Launcher wrapper

    waybar # Bar
    wofi # Launcher

    libappindicator # For waybar tray

    # File manager
    xfce.thunar
    xfce.thunar-volman

    pavucontrol # Sound settings
    pulseaudio # For pactl

    networkmanagerapplet # Network

    brightnessctl # Backlight

    wlr-randr # Xrandr replacement

    mako # Notifications

    # Screen locking
    swaylock-effects
    swayidle
    
    configure-gtk
    lxappearance # Appearance
    glib
    qogir-icon-theme # Qogir cursors
    nordic
    arc-icon-theme
    catppuccin-gtk
  ];
}
