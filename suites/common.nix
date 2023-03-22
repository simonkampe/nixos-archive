{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Note taking
    obsidian

    # Keyboard
    uhk-agent
    wally-cli

    # Syncing
    syncthingtray
  ];

  services = {
    syncthing.enable = true;
  };

  services.udev.packages = with pkgs; [
    uhk-udev-rules
  ];
}
