{ nixos-raspberrypi, ... }:
{
  boot.loader.raspberry-pi.bootloader = "kernel";
  imports = with nixos-raspberrypi.nixosModules.raspberry-pi-5; [
    base
    display-vc4
  ];
}