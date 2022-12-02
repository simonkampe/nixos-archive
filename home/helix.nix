{ config, pkgs, ... }:

{
  programs.helix = {
    enable = true;

    languages = [ ];

    settings = {
      theme = "nord";
    };

    themes = { };
  };
}

