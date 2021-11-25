{ pkgs, ... }:

{

  hardware = {
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

    #tlp = {
    #  enable = true;
    #  settings = {
    #    CPU_SCALING_GOVERNOR_ON_BAT="powersave";
    #    CPU_SCALING_GOVERNOR_ON_AC="performance";

    #    # The following prevents the battery from charging fully to
    #    # preserve lifetime. Run `tlp fullcharge` to temporarily force
    #    # full charge.
    #    # https://linrunner.de/tlp/faq/battery.html#how-to-choose-good-battery-charge-thresholds
    #    #START_CHARGE_THRESH_BAT0=40;
    #    #STOP_CHARGE_THRESH_BAT0=50;

    #    # 100 being the maximum, limit the speed of my CPU to reduce
    #    # heat and increase battery usage:
    #    CPU_MAX_PERF_ON_AC=100;
    #    CPU_MAX_PERF_ON_BAT=50;
    #  };
    #};
  };

  # rtkit is optional but recommended
  #services.pipewire = {
  #  enable = true;
  #  alsa.enable = true;
  #  alsa.support32Bit = true;
  #  pulse.enable = true;
  #  # If you want to use JACK applications, uncomment this
  #  #jack.enable = true;

  #  # use the example session manager (no others are packaged yet so this is enabled by default,
  #  # no need to redefine it in your config for now)
  #  #media-session.enable = true;

  #  media-session.config.bluez-monitor.rules = [
  #  {
  #    # Matches all cards
  #    matches = [ { "device.name" = "~bluez_card.*"; } ];
  #    actions = {
  #      "update-props" = {
  #        "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
  #        # mSBC is not expected to work on all headset + adapter combinations.
  #        "bluez5.msbc-support" = true;
  #        # SBC-XQ is not expected to work on all headset + adapter combinations.
  #        "bluez5.sbc-xq-support" = true;
  #      };
  #    };
  #  }
  #  {
  #    matches = [
  #      # Matches all sources
  #      { "node.name" = "~bluez_input.*"; }
  #      # Matches all outputs
  #      { "node.name" = "~bluez_output.*"; }
  #    ];
  #    actions = {
  #      "node.pause-on-idle" = false;
  #    };
  #  }];
  #};
}
