{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    libreoffice
    obs-studio
    cifs-utils
    samba
    remmina # RDP client
    teamviewer
    chromium
  ];

  programs.firejail = {
    enable = true;

    wrappedBinaries = {
      kauto-office = {
        executable = "${pkgs.chromium}/bin/chromium --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer --ozone-platform=wayland https://outlook.office.com https://teams.microsoft.com";
        profile = "${pkgs.firejail}/etc/firejail/chromium.profile";
        extraArgs = [ "--private=~/.local/share/firejail/chromium-kauto" ];
      };
      esab-office = {
        executable = "${pkgs.chromium}/bin/chromium --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer --ozone-platform=wayland https://outlook.office.com https://teams.microsoft.com";
        profile = "${pkgs.firejail}/etc/firejail/chromium.profile";
        extraArgs = [ "--private=~/.local/share/firejail/chromium-esab" ];
      };
    };
  };

  services = {
    onedrive.enable = true;
    teamviewer.enable = true;

    printing = {
      enable = true;
      drivers = [ pkgs.canon-cups-ufr2 ];
    };
  };
}
