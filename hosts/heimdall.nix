{ pkgs, lib, config, ... }:

{
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes";
  };

  #imports =
  #  [
  #    ./hardware-configuration.nix
  #  ];

  # Enable NTFS support
  boot.supportedFilesystems = [ "ntfs" ];

  networking = {
    hostName = "heimdall";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  environment.systemPackages = with pkgs; [
    # Nvidia
    #nvidia-offload

    # Utils
    alacritty
    ag
    gparted

    # Media
    spotify
    vlc

    # Web
    firefox
    mailspring
    element-desktop

    # Dev
    git
    virt-manager
    unzip
    wineWowPackages.stable
    winetricks
    #vmware-vdiskmanager

    # Editor
    (unstable.neovim.override {
      viAlias = true;
      vimAlias = true;
    })
  ];

  #hardware.nvidia.prime = {
  #  offload.enable = true;
  #  intelBusId = "PCI:0:2:0";
  #  nvidiaBusId = "PCI:1:0:0";
  #};

  # Need this to build for Raspberry Pi aarch64
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.virtualbox.host.enable = true;
  programs.dconf.enable = true;

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  services = {
    avahi.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    gnome.gnome-keyring.enable = true;

    printing = {
      enable = true;
      drivers = [ pkgs.canon-cups-ufr2 ];
    };

    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_BAT="powersave";
        CPU_SCALING_GOVERNOR_ON_AC="performance";

        # The following prevents the battery from charging fully to
        # preserve lifetime. Run `tlp fullcharge` to temporarily force
        # full charge.
        # https://linrunner.de/tlp/faq/battery.html#how-to-choose-good-battery-charge-thresholds
        #START_CHARGE_THRESH_BAT0=40;
        #STOP_CHARGE_THRESH_BAT0=50;

        # 100 being the maximum, limit the speed of my CPU to reduce
        # heat and increase battery usage:
        CPU_MAX_PERF_ON_AC=100;
        CPU_MAX_PERF_ON_BAT=50;
      };
    };
  };

  programs.seahorse.enable = true;

  users.mutableUsers = true;
  users.users.simon = {
    isNormalUser = true;
    description = "";
    group = "users";
    password = "Linetic1";
    extraGroups = [ "wheel" "networkmanager" "docker" "audio" "libvirtd" "vboxusers" ];
    shell = pkgs.fish;
  };

  nix.trustedUsers = [ "root" "simon" ];
}
