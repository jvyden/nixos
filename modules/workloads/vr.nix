{ nixpkgs-xr, pkgs, ... }:
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
      pkgs.wivrn.override {
        cudaSupport = true;
      }
    );
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
