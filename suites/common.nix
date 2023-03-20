{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Note taking
    obsidian

    # Keyboard
    uhk-agent
    wally-cli
  ];

  services.udev.packages = with pkgs; [
    uhk-udev-rules
  ];
}
