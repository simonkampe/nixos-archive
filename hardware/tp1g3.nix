{ pkgs, ... }:

{

  hardware = {
    pulseaudio = {
      enable = true;
      support32Bit = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      package = pkgs.pulseaudioFull;
    };

    bluetooth = {
      enable = true;

      # Enable A2DP
      #General = {
      #  Enable = "Source,Sink,Media,Socket";
      #};
    };
  };

  services = {
    blueman.enable = true;
  };
}
