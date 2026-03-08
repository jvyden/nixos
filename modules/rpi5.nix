{ nixos-raspberrypi, ... }:
{
  imports = with nixos-raspberrypi.nixosModules.raspberry-pi-5; [
    base
    display-vc4
  ];
}