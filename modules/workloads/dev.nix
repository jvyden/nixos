{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # languages
    gcc
    clang
    dotnetCorePackages.sdk_10_0
    nixfmt
    gdb
    # tools, IDEs, debuggers
    angryipscanner
    zed-editor
    jetbrains.rider
    avalonia-ilspy
    imhex
    gdb
    nixd
    nil
  ];

  virtualisation.docker.enable = true;
  users.users.jvyden.extraGroups = [ "docker" ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
