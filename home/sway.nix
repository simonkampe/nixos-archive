{ config, pkgs, ... }:
let
  laptop_screen = "eDP-1";
  u4919dw = "Dell Inc. Dell U4919DW DMRWTY2";

  # bash script to let dbus know about important env variables and
  # propogate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts  
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
      name = "configure-gtk";
      destination = "/bin/configure-gtk";
      executable = true;
      text = let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Nordic'
        gsettings set $gnome-schema icon-theme 'Paper'
        # gsettings set $gnome-schema cursor-theme 'Numix'
        gsettings set $gnome-schema cursor-size '32'
        # gsettings set $gnome-schema font-name 'Your font name'
        '';
  };
in
{ 
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      modifier = "Mod1";
      input = {
        "type:keyboard" = {
          xkb_layout = "se";
        };
        "type:touchpad" = {
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "enabled";
          middle_emulation = "enabled";
        };
      };
      terminal = "alacritty";
      menu = "wofi --allow-icons --show drun,run | xargs swaymsg exec --";
      # Status bar(s)
      bars = [ ];
      # Display device configuration
      output = {
        laptop_screen = {
          scale = "2";
        };
        u4919dw = {
          resolution = "5120x1440";
          scale = "1.2";
        };
      };
      gaps = {
        inner = 2;
        outer = 2;
        smartBorders = "on";
        smartGaps = true;
      };
      window = {
        border = 1;
      };
    };

    extraConfig = ''
      ### Variables
      #
      # Logo key. Use Mod1 for Alt.
      set $mod Mod1
      set $altmod Mod4

      # Home row direction keys, like vim
      set $left h
      set $down j
      set $up k
      set $right l

      ### Output configuration
      #
      # Default wallpaper (more resolutions are available in @datadir@/backgrounds/sway/)
      output * bg ~/.wallpaper fill

      set $laptop eDP-1

      bindswitch --reload --locked lid:on output $laptop disable
      bindswitch --reload --locked lid:off output $laptop enable

       ### Key bindings
      #
      # Basics:
      #
          # Start a floating terminal
          bindsym $altmod+Return exec 'alacritty --title "Alafloat"'
          for_window [ title="Alafloat" ] floating enable

          # EWW
          bindsym $mod+Backspace exec eww -c /home/simon/.dotfiles/config/eww/hyprbar/ open-many bar --toggle

          # Drag floating windows by holding down $mod and left mouse button.
          # Resize them with right mouse button + $mod.
          # Despite the name, also works for non-floating windows.
          # Change normal to inverse to use left mouse button for resizing and right
          # mouse button for dragging.
          floating_modifier $mod normal

          # Suspend
          bindsym $altmod+z exec systemctl suspend

          # Lock
          bindsym $altmod+l exec swaylock

          bindsym $mod+Tab workspace back_and_forth

          # Special workspaces
          set $web ""
          set $mail ""
          set $chat ""
          set $media ""

          bindsym $altmod+1 workspace $web
          bindsym $altmod+2 workspace $mail
          bindsym $altmod+3 workspace $chat
          bindsym $altmod+4 workspace $media

          bindsym $altmod+Shift+1 move container to workspace $web
          bindsym $altmod+Shift+2 move container to workspace $mail
          bindsym $altmod+Shift+3 move container to workspace $chat
          bindsym $altmod+Shift+4 move container to workspace $media

      #
      # Assign windows
      #
          #assign [class="Firefox"] workspace $web

          assign [class="Mailspring"] workspace $mail

          assign [class="Element"] workspace $chat

          assign [class="Spotify*"] workspace $media
          assign [app_id="pavucontrol"] workspace $media

      #
      # Utils
      #
          # Brightness
          bindsym XF86MonBrightnessDown exec "brightnessctl set 5%-"
          bindsym XF86MonBrightnessUp exec "brightnessctl set +5%"

          # Volume
          bindsym XF86AudioRaiseVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'
          bindsym XF86AudioLowerVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'
          bindsym XF86AudioMute exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'

      #
      # Status Bar:
      #
      # Read `man 5 sway-bar` for more information about this section.
      bar {
          swaybar_command waybar
      }

      #
      # Set GTK theme
      #
      set $gnome-schema org.gnome.desktop.interface

      exec {
          mako
          udiskie --appindicator -t
          blueman-applet
      }

      exec_always {
        dbus-sway-environment
        configure-gtk
        makoctl reload
      }

      include @sysconfdir@/sway/config.d/*
    '';
  };

  home.packages = with pkgs; [
    # Workarounds
    dbus-sway-environment
    configure-gtk

    # Appearance
    nordic
    paper-gtk-theme
    paper-icon-theme

    wofi
    swaylock
    libnotify
    blueman
    brightnessctl
    wl-clipboard
    pavucontrol
    pulseaudio # for pactl
    glib # for gsettings
    xfce.thunar
    xfce.thunar-volman
    xfce.xfconf
    xfce.tumbler
  ];

  home.sessionVariables = {
    _JAVA_AWT_VM_NONREPARENTING = 1;
  };

  programs.swaylock.settings = {
    color = "808080";
    font-size = 24;
    indicator-idle-visible = true;
    indicator-radius = 100;
    line-color = "ffffff";
    show-failed-attempts = true;
  };

  services.kanshi = {
    enable = true;
  };

  services.network-manager-applet.enable = true;

  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "always";
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      { timeout = 300; command = "swaylock"; }
      { timeout = 420; command = "swaymsg \"output * dpms off\""; resumeCommand = "swaymsg \"output * dpms on\""; }
      { timeout = 600; command = "systemctl suspend"; }
    ];
    events = [
      { event = "before-sleep"; command = "swaylock"; }
    ];
  };

  programs.waybar = {
    enable = true;
    style = config/waybar/style.css;
    settings = {
      topBar = {
        layer = "top";
        position = "top";
        margin = "2px 5px";

        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];
        
        modules-center = [ "sway/window" ];
        
        modules-right = [
          "pulseaudio"
          "backlight"
          "battery"
          "idle_inhibitor"
          "clock#date"
          "clock#time"
        ];

        "backlight" = {
          device = "intel_backlight";
          format = "{percent}% {icon}";
          format-icons = [ "" "" ];
          on-scroll-up = "brightnessctl -c backlight set 1%+";
          on-scroll-down = "brightnessctl -c backlight set 1%-";
        };

        "battery" = {
          interval = 10;
          states = {
              warning = 30;
              critical = 15;
          };
          # Connected to AC
          format = "  {icon}  {capacity}%"; # Icon: bolt
          # Not connected to AC
          format-discharging = "{icon}  {capacity}%";
          format-icons = [
            "" # Icon: battery-full
            "" # Icon: battery-three-quarters
            "" # Icon: battery-half
            "" # Icon: battery-quarter
            "" # Icon: battery-empty
          ];
          tooltip = true;
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
              activated = "";
              deactivated = "";
          };
        };

        "clock#time" = {
          interval = 1;
          format = "{:%H:%M:%S}";
          tooltip = false;
        };

        "clock#date" = {
          interval = 10;
          format = "  {:%Y-%m-%d}"; # Icon: calendar-alt
          tooltip-format = "{:%e %B %Y}";
        };

        "sway/mode" = {
          format = "<span style=\"italic\">  {}</span>"; # Icon: expand-arrows-alt
          tooltip = false;
        };

        "sway/window" = {
          format = "{}";
          max-length = 120;
        };

        "sway/workspaces" = {
          all-outputs = false;
          disable-scroll = true;
          format = "{icon} {name}";
          format-icons = {
            "1:www" = "龜";       # Icon: firefox-browser
            "2:mail" = "";       # Icon: mail
            "3:editor" = "";     # Icon: code
            "4:terminals" = "";  # Icon: terminal
            "5:portal" = "";     # Icon: terminal
            urgent = "";
            focused = "";
            default = "";
          };
        };

        pulseaudio = {
          #"scroll-step": 1,
          format = "{icon}  {volume}%";
          format-bluetooth = "{icon}  {volume}% ";
          format-muted = "";
          format-icons = {
            headphones = "";
            handsfree = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" ];
          };
          on-click = "pavucontrol";
        };
      };
      bottomBar = {
        layer = "top";
        position = "bottom";
        margin = "2px 5px";

        modules-left = [
          "network"
          "memory"
          "cpu"
          "temperature"
        ];

        modules-center = [ ];

        modules-right = [
          "tray"
        ];

        "cpu" = {
          "interval" = 5;
          "format" = "  {usage}% ({load})"; # Icon: microchip
          "states" = {
            "warning" = 70;
            "critical" = 90;
          };
        };

        "temperature" = {
          "thermal-zone" = 12;
          "critical-threshold" = 80;
          "interval" = 5;
          "format" = "{icon}  {temperatureC}°C";
          "format-icons" = [
            "" # Icon: temperature-empty
            "" # Icon: temperature-quarter
            "" # Icon: temperature-half
            "" # Icon: temperature-three-quarters
            "" # Icon: temperature-full
          ];
          "tooltip" = true;
        };

        "tray" = {
          "icon-size" = 16;
          "spacing" = 10;
        };

        "network" = {
          "interval" = 5;
          "format-wifi" = "  {essid} ({signalStrength}%)"; # Icon: wifi
          "format-ethernet" = "  {ifname}: {ipaddr}/{cidr}"; # Icon: ethernet
          "format-disconnected" = "⚠  Disconnected";
          "tooltip-format" = "{ifname}: {ipaddr}";
        };

        "memory" = {
            "interval" = 5;
            "format" = "  {}%"; # Icon: memory
            "states" = {
                "warning" = 70;
                "critical" = 90;
            };
        };
      };
    };
  };

  # Notification daemon
  programs.mako = {
    enable = true;
    maxVisible = 10;
    layer = "top";
    font = "Sarasa UI SC 10";
    backgroundColor = "#4C566A";
    textColor = "#D8DEE9";
    borderColor = "#434C53";
    borderRadius = 7;
    maxIconSize = 48;
    defaultTimeout = 4000;
    anchor = "top-right";
    margin = "20";
  };

  ## Widgets
  #programs.eww = {
  #  enable = true;
  #  package = pkgs.eww-wayland;
  #  configDir = ../eww;
  #};

  ## Required for EWW
  #programs.pywal.enable = true;

  ## Required for EWW
  #services.playerctld.enable = true;

  ## Required for EWW
  #home.packages = with pkgs; [
  #  alsa-utils
  #  lm_sensors
  #];
}



