{ pkgs, lib, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
{
  environment.systemPackages = [
    nvidia-offload
    pkgs.libcamera
    pkgs.libinput
  ];

  services.hardware.bolt.enable = true;
  services.udev.extraRules = ''
    # Always authorize thunderbolt connections when they are plugged in.
    # This is to make sure the USB hub of Thunderbolt is working.
    ACTION=="add", SUBSYSTEM=="thunderbolt", ATTR{authorized}=="0", ATTR{authorized}="1"
    
    # See https://www.reddit.com/r/NixOS/comments/l2ab4i/nvidia_prime_offload_on_dell_xps_7590/
    
    # Remove NVIDIA USB xHCI Host Controller devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{remove}="1"
    
    # Remove NVIDIA USB Type-C UCSI devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{remove}="1"
    
    # Remove NVIDIA Audio devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{remove}="1"
    
    # Enable runtime PM for NVIDIA VGA/3D controller devices on driver bind
    ACTION=="bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="auto"
    ACTION=="bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TEST=="power/control", ATTR{power/control}="auto"
    
    # Disable runtime PM for NVIDIA VGA/3D controller devices on driver unbind
    ACTION=="unbind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="on"
    ACTION=="unbind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TEST=="power/control", ATTR{power/control}="on"
  '';

  hardware = {
    bluetooth = {
      enable = true;
    };
  };

  ##############
  # Sound
  ##############
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };
  environment.etc = {
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text =
    ''
      bluez_monitor.properties = {
        ["bluez5.enable-sbc-xq"] = true,
        ["bluez5.enable-msbc"] = true,
        ["bluez5.enable-hw-volume"] = true,
        ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
    '';
  };

  ##############
  # Video
  ##############
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    nvidia = {
      powerManagement.enable = true;
      modesetting.enable = true;
      open = false;

      prime.offload.enable = true;
      #prime.sync.enable = true;
      prime = {
        # Bus ID of the Intel GPU.
        intelBusId = lib.mkDefault "PCI:0:2:0";
        # Bus ID of the NVIDIA GPU.
        nvidiaBusId = lib.mkDefault "PCI:1:0:0";
      };
    };

    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
  };

  # Better powersaving for nvidia (https://www.reddit.com/r/NixOS/comments/l2ab4i/nvidia_prime_offload_on_dell_xps_7590/)
  boot.extraModprobeConfig = "options nvidia \"NVreg_DynamicPowerManagement=0x02\"\n";

  #specialisation = {
  #  external-display.configuration = {
  #    system.nixos.tags = [ "external-display" ];
  #    hardware.nvidia.prime.offload.enable = lib.mkForce false;
  #    hardware.nvidia.powerManagement.enable = lib.mkForce false;
  #  };
  #};
}
