{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.simon = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    password = "changethis";
    shell = pkgs.fish;
  };
}
