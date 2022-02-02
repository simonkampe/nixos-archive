{ pkgs, lib, config, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes";
  };
  
  services.xserver.videoDrivers = [ "nvidia" ];

  #imports =
  #  [
  #    ./hardware-configuration.nix
  #  ];

  # Enable NTFS support
  boot.supportedFilesystems = [ "ntfs" ];

  networking = {
    hostName = "mendelevium";
    networkmanager.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # Utils
    ag
    gparted
    refind

    # Media
    spotify
    vlc

    # Web
    firefox
    element-desktop

    # Dev
    git
    unzip

    # Editor
    unstable.helix
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
  #boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  #virtualisation.docker.enable = true;
  #virtualisation.libvirtd.enable = true;
  #virtualisation.virtualbox.host.enable = true;
  #programs.dconf.enable = true;

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  services = {
    avahi.enable = true;
    #gvfs.enable = true;
    #udisks2.enable = true;
    #gnome.gnome-keyring.enable = true;

    printing = {
      enable = true;
      drivers = [ pkgs.canon-cups-ufr2 ];
    };
  };

  #programs.seahorse.enable = true;

  users.mutableUsers = true;
  users.users.simon = {
    isNormalUser = true;
    description = "";
    group = "users";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.fish;
  };

  nix.trustedUsers = [ "root" "simon" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11";
}
