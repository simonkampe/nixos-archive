{ config, pkgs, ... }:

{
  programs.helix = {
    enable = true;

    languages = { 
      language = [{
        name = "cpp";
        language-server = { command = "clangd"; };
      }];
    };

    settings = {
      theme = "nord";

      editor = {
        line-number = "relative";
        mouse = true;

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        file-picker = {
          hidden = false;
        };
      };
    };
  };
}

