{ pkgs, ... }:
{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      glibc
      stdenv.cc.cc.lib
      libGL
      libX11
      libXcursor
      libXrandr
      udev
      gtk3
      gdk-pixbuf
      glib
      libxml2
      libxml2_13
      xml2
      libz
      opencl-headers
    ];
  };
}
