{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    tree
    htop
    btop
    fastfetch
    nano
    agenix-cli
    lsof
    tmux
    file
    usbutils
    pciutils
    lshw
  ];
}