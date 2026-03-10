{ lib, ... }:
{
  services.auto-cpufreq.enable = lib.mkForce false;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
}
