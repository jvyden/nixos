{
  nix-cachyos-kernel,
  pkgs,
  lib,
  ...
}:
let
  kernel = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v3;
in
{
  nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned ];

  boot.kernelPackages = lib.mkForce kernel;
}
