{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    _86box-with-roms
  ];
}
