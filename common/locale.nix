{ pkgs, ... }:

{
  time = {
    timeZone = "Europe/Stockholm";
    hardwareClockInLocalTime = true;
  };

  services.timesyncd.enable = true;

  console.keyMap = "sv-latin1";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "sv_SE.UTF-8/UTF-8" ];
    extraLocaleSettings = {
      LC_MEASUREMENT = "sv_SE.UTF-8";
      LC_NUMERIC = "sv_SE.UTF-8";
      LC_TIME = "sv_SE.UTF-8";
    };
  };

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "Hermit" "Iosevka" ]; })
    comfortaa
    noto-fonts
    material-design-icons
  ];
}
