{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    master.snapmaker-luban
    blender
    freecad
    gimp
    master.inkscape
    master.lightburn
    master.k40-whisperer
  ];

  # Udev for laser cutter
  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="5512", ENV{DEVTYPE}="usb_device", GROUP="users", MODE="0777"
  '';
}
