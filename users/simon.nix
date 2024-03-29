{ pkgs, ... }:

{
  programs.fish.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.simon = {
    description = "Simon Kämpe";
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "wireshark" "lp" "networkmanager" "input" "audio" "libvirtd" "adbusers" ];
    password = "changethis";
    shell = pkgs.fish;
  };
}
