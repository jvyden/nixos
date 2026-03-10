{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    angryipscanner
    vscodium
    avalonia-ilspy
    imhex
    jetbrains.rider
  ];
}
