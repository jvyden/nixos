{ kwin-effects-better-blur-dx, pkgs, lib, ... }:
{
  services.auto-cpufreq.enable = lib.mkForce false;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.plasma-login-manager.enable = true;

  environment.etc."plasmalogin.conf.d/98-bg.conf".text = ''
    [Greeter][Wallpaper][org.kde.image][General]
    Image=file://${../assets/wallpapers/bg3.jpg}
  '';

  environment.systemPackages = [
    kwin-effects-better-blur-dx.packages.${pkgs.system}.default # Wayland
  ];
}
