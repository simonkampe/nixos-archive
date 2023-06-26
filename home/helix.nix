{ config, pkgs, ... }:

{
  programs.helix = {
    enable = true;

    languages = { language = [ ]; };

    settings = {
      theme = "nord";
    };

    themes = { };
  };
}

