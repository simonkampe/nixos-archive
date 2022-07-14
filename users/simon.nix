{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.simon = {
    description = "Simon Kämpe";
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    password = "changethis";
    shell = pkgs.fish;
  };
}
