{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    thunderbird
    globalprotect-openconnect
  ];

  services.globalprotect = {
    enable = true;
    # if you need a Host Integrity Protection report
    csdWrapper = "${pkgs.openconnect}/libexec/openconnect/hipreport.sh";
  };
}

