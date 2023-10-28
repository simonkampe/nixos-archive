{ config, pkgs, ... }:
{
  nix.nixPath = [ "nixpkgs=${pkgs.outPath}" ];

  environment.systemPackages = with pkgs; [
    # Keyboard
    uhk-agent
    wally-cli
  ];

  services.udev.packages = with pkgs; [
    uhk-udev-rules
  ];
}
