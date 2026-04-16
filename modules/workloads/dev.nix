{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # languages
    gcc
    clang
    dotnetCorePackages.sdk_10_0
    nixfmt
    # tools, IDEs, debuggers
    angryipscanner
    vscodium
    jetbrains.rider
    avalonia-ilspy
    imhex
    gdb
  ];
}
