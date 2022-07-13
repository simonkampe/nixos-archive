{ pkgs, ... }:

{
  hardware = {
    bluetooth = {
      enable = true;
    };

    #pulseaudio = {
    #  enable = true;
    #  support32Bit = true;
    #};
  };

  #nixpkgs.config.pulseaudio = true;

  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Fix DPI
  hardware.video.hidpi.enable = true;
  #environment.variables = {
  #  GDK_SCALE = "2";
  #  GDK_DPI_SCALE = "0.5";
  #  _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  #};

  services.xserver.videoDrivers = [ "displaylink" "modesetting" ];
}
