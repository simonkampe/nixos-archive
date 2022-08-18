{ config, pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    kmail
    teams
    inputs.ethercat.packages.x86_64-linux.ethercat
  ];
}

