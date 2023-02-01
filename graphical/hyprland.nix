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

      XDG_CURRENT_DESKTOP=Hyprland
      XDG_SESSION_TYPE=wayland
      XDG_SESSION_DESKTOP=Hyprland

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

  # Power management
  services.power-profiles-daemon.enable = false;
  services.upower.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_BAT="powersave";
      CPU_SCALING_GOVERNOR_ON_AC="performance";

      # The following prevents the battery from charging fully to
      # preserve lifetime. Run `tlp fullcharge` to temporarily force
      # full charge.
      # https://linrunner.de/tlp/faq/battery.html#how-to-choose-good-battery-charge-thresholds
      START_CHARGE_THRESH_BAT0=80;
      STOP_CHARGE_THRESH_BAT0=95;

      # 100 being the maximum, limit the speed of my CPU to reduce
      # heat and increase battery usage:
      CPU_MAX_PERF_ON_AC=100;
      CPU_MAX_PERF_ON_BAT=70;
    };
  };

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
    WLR_DRM_DEVICES="/dev/dri/card0:/dev/dri/card1"; # see https://github.com/swaywm/sway/wiki#i-have-a-multi-gpu-setup-like-intelnvidia-or-intelamd-and-sway-does-not-start
    #GBM_BACKEND="nvidia-drm";
    #__GLX_VENDOR_LIBRARY_NAME="nvidia";
    #LIBVA_DRIVER_NAME="nvidia";
    __GL_GSYNC_ALLOWED="0";
    __GL_VRR_ALLOWED="0";
    WLR_DRM_NO_ATOMIC="1";

    SDL_VIDEODRIVER="wayland";
    _JAVA_AWT_WM_NONEREPARENTING="1";
    CLUTTER_BACKEND="wayland";
    GDK_BACKEND="wayland,x11";
    #WLR_RENDERER="vulkan";
    #WLR_DRM_NO_MODIFIERS="1";
    #XWAYLAND_NO_GLAMOR = "1";
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

    powertop # Power consumption analysis

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

    seatd
  ];
}
