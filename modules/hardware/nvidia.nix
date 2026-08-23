{ pkgs, config, ... }:
let
  package = config.boot.kernelPackages.nvidiaPackages.bleeding_edge.overrideAttrs (old: {
    passthru = old.passthru // {
      open = old.passthru.open.overrideAttrs (o: {
        patches = (o.patches or [ ]) ++ [ ./nvidia-open-gpio-device-const.patch ];
      });
    };
  });
in
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
    package = package;
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
      args = [ ];
      path = "nvidia-container-runtime";
    };
  };
  hardware.nvidia-container-toolkit = {
    enable = true;
  };
}
