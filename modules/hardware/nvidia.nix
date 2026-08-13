{ pkgs, config, ... }:
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
    package = config.boot.kernelPackages.nvidiaPackages.bleeding_edge;
  };

  boot.blacklistedKernelModules = [ "nouveau" ];

  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia
    nvidia-container-toolkit
  ];

  services.lact.enable = true;

  # software tweaks
  programs.obs-studio.package = (
    pkgs.obs-studio.override {
      cudaSupport = true;
    }
  );

  # distrobox compat
  virtualisation.docker.daemon.settings = {
    features.cdi = true;
    runtimes.nvidia = {
      args = [];
      path = "nvidia-container-runtime";
    };
  };
  hardware.nvidia-container-toolkit = {
    enable = true;
  };
}
