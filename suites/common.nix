{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Keyboard
    uhk-agent
    wally-cli
  ];

  services.udev.packages = with pkgs; [
    uhk-udev-rules
  ];
}
