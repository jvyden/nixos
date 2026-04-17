{ lib, ... }:
{
  services.auto-cpufreq.enable = lib.mkForce false;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.plasma-login-manager = {
    enable = true;
  };
}
