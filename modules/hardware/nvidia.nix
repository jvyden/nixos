{ pkgs, ... }:
{
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  nixpkgs.config = {
    allowUnfree = true;
    # cudaSupport = true; # holy hell this rebuilds a lot of stuff
  };

  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
  };

  boot.blacklistedKernelModules = [ "nouveau" ];

  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia
  ];

  services.lact.enable = true;

  # software tweaks
  programs.obs-studio.package = (
    pkgs.obs-studio.override {
      cudaSupport = true;
    }
  );
}
