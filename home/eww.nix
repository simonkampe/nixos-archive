{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    configDir = ./config/eww;
  };

  home.packages = with pkgs; [
    bc
    blueberry
    bluez
    coreutils
    dbus
    dunst
    findutils
    gawk
    gnused
    gojq
    imagemagick
    iwgtk
    jaq
    light
    networkmanager
    networkmanagerapplet
    pavucontrol
    playerctl
    procps
    pulseaudio
    ripgrep
    socat
    udev
    upower
    util-linux
    wget
    wireplumber
    wlogout
    wofi
  ];
/*
  systemd.user.services.eww = {
    Unit = {
      Description = "Eww Daemon";
      # not yet implemented
      # PartOf = ["tray.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
      ExecStart = "${config.programs.eww.package}/bin/eww daemon --no-daemonize";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };*/
}
