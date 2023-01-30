{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    brave

    # Keyboard
    uhk-agent
    wally-cli
  ];

  services.udev.packages = with pkgs; [
    uhk-udev-rules
  ];
}
