{ config, pkgs, ... }:

{
  xdg.desktopEntries = {
    ka-office = {
      name = "KA Office";
      genericName = "Web Browser";
      exec = ''firejail --private="~/.local/share/firejail/chromium-kauto" ${pkgs.chromium}/bin/chromium https://outlook.office.com https://teams.microsoft.com'';
      terminal = true;
      icon = "chromium";
      categories = [ "Application" "Office" ];
    };

    esab-office = {
      name = "ESAB Office";
      genericName = "Web Browser";
      exec = ''firejail --private="~/.local/share/firejail/chromium-esab" ${pkgs.chromium}/bin/chromium https://outlook.office.com https://teams.microsoft.com'';
      terminal = true;
      icon = "chromium";
      categories = [ "Application" "Office" ];
    };
  };
}
