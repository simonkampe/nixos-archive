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
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;
  # Use latest kernel
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  # Enable NTFS support
  boot.supportedFilesystems = [ "ntfs" ];
  #boot.extraModulePackages = [ pkgs.simon.linuxPackages_latest.vmware-host-modules ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes";
  };

  #nixpkgs.config.packageOverrides = pkgs: {
  #  linuxPackages_latest = pkgs.unstable.linuxPackages_latest;
  #  nvidia_x11 = pkgs.unstable.nvidia_x11;
  #};

  #services.xserver.videoDrivers = [ "nvidia" ];

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
    killall
    parted
    wget
    curl
    #debootstrap
    xorg.xhost # Allow X app to run as root with "xhost si:localuser:root", disallow with "xhost -si:localuser:root"
    imagemagick
    #gimp
    xdg-utils

    # Media
    #spotify
    #spicetify-cli
    #vlc
    #pulseaudio # For pactl

    # Web
    firefox
    #mailspring
    element-desktop
    #signal-desktop

    # Dev
    git
    #virt-manager
    unzip
    docker-compose
    #wineWowPackages.stable
    #winetricks
    #vmware-vdiskmanager

    # Artsy
    #lightburn
    #inkscape
    #unstable.snapmaker-luban

    # Editor
    (unstable.neovim.override {
      viAlias = true;
      vimAlias = true;
    })

    # Office
    #libreoffice
  ];

  #hardware.nvidia.prime = {
  #  offload.enable = true;
  #  intelBusId = "PCI:0:2:0";
  #  nvidiaBusId = "PCI:1:0:0";
  #};

  programs.dconf.enable = true;
  programs.gnupg.agent.enable = true;

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  # Debian chroot
  #systemd.targets.machines.enable = true;
  #systemd.nspawn."debian-bullseye" = {
  #  enable = true;
  #  execConfig = {
  #    Boot = true;
  #    Environment = "DISPLAY=:0";
  #  };
  #  filesConfig = {
  #    "BindReadOnly" = [
  #      "/tmp/.X11-unix"
  #    ];
  #    "Bind" = [
  #      "/data"
  #    ];
  #  };
  #  networkConfig = {
  #    Private = false;
  #    VirtualEthernet = false;
  #  };
  #};
  #systemd.services."systemd-nspawn@debian-bullseye" = {
  #  enable = true;
  #  wantedBy = lib.mkForce [ ];#[ "machines.target" ];
  #};
  security.rtkit.enable = true;

  services = {
    avahi.enable = true;

    printing = {
      enable = true;
      #drivers = [ pkgs.canon-cups-ufr2 ];
    };

  };

  users.mutableUsers = true;
  users.users.linetic = {
    isNormalUser = true;
    description = "";
    group = "users";
    password = "Linetic1";
    extraGroups = [ "wheel" "networkmanager" "docker" "audio" "libvirtd" "vboxusers" ];
    shell = pkgs.fish;
  };

  nix.trustedUsers = [ "root" "linetic" ];
}
