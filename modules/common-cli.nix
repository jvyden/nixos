{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    tree
    htop
    btop
    fastfetch
    nano
  ];
}