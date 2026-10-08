{ nixpkgs-xr, pkgs, lib, ... }:
{
  imports = [
    nixpkgs-xr.nixosModules.nixpkgs-xr
  ];

  services.wivrn = {
    enable = true;
    openFirewall = true;
    highPriority = true;

    steam = {
      enable = true;
      importOXRRuntimes = true;
    };

    config = {
      enable = true;
      json = {
        application = [
          pkgs.wayvr
          "--show"
        ];
      };
    };

    package = (
      pkgs.wivrn.overrideAttrs (finalAttrs: prevAttrs: {
        cudaSupport = true;
        cmakeFlags = (prevAttrs.cmakeFlags or []) ++ [
          (lib.cmakeBool "WIVRN_FEATURE_DEBUG_GUI" true)
        ];
        buildInputs = (prevAttrs.buildInputs or []) ++ [
          pkgs.sdl2-compat
        ];
      }
    ));
  };

  environment.systemPackages = with pkgs; [
    xr-hardware
    wayvr
    xrizer
    vrcx
    bs-manager
  ];

  services.udev.packages = with pkgs; [ xr-hardware ];
}
