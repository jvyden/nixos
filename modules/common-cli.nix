{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    config = {
      user = {
        name = "jvyden";
        email = "jvyden@jvyden.xyz";
      };
    };
  };

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