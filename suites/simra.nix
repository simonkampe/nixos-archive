{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gnucash
  ];
}
