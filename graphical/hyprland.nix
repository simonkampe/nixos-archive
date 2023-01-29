{ lib, pkgs, config, ... }:
{
  programs.hyprland.enable = true;
  
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
    };
    displayManager.gdm = {
      enable = true;
    };
  };

  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  fonts.fonts = with pkgs; [
    material-icons
    material-design-icons
  ];

  programs.dconf.enable = true;

  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    eww-wayland # Bar
    wofi # Launcher
    dunst # Notifications
    lxappearance
    networkmanagerapplet
    libinput
  ];
}
