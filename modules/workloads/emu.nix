{
  pkgs,
  fetchFromGitHub,
  ...
}:

let
  _86box_overlay = (
    self: super: {
      _86box-with-roms = super._86box-with-roms.overrideAttrs (prev: {
        version = "git";
        src = pkgs.fetchFromGitHub {
          owner = "86Box";
          repo = "86Box";
          rev = "06f3706c3710e8798373e5991c19234840932f8e";
          hash = "sha256-yRpTVm6guiKJ4Shx8A/2462a3W11U39ecn9C+7u4vpQ=";
        };
        patches = [ ];
        passthru.roms = pkgs.fetchFromGitHub {
          owner = "86Box";
          repo = "roms";
          rev = "34445a5683402b8ee6f2b09feba242e04eaaf17d";
          hash = "sha256-UoezMIfGxDWdtY0p6Ygm+HFAp1GVH+LQYsSCX6WO9F0=";
        };
        postInstall = (builtins.replaceStrings [ "96 " "192 " " 512" ] [ "" "" "" ] prev.postInstall);
      });
    }
  );
in
{
  nixpkgs.overlays = [ _86box_overlay ];
  environment.systemPackages = with pkgs; [
    _86box-with-roms
  ];
}
