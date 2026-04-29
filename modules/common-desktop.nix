{ pkgs, self, ... }:
{
  imports = [
    ./kde.nix
  ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  hardware.graphics.enable = true;
  hardware.opentabletdriver.enable = true;

  networking = {
    networkmanager = {
      enable = true;
      dns = "none";
      wifi.powersave = true;
    };
    useDHCP = false;
    dhcpcd.enable = false;
  };

  services.pipewire.enable = true;
  xdg.portal = {
    enable = true;
  };

  # electron slop may use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = [ pkgs.kdePackages.plasma-browser-integration ];
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
  };

  environment.systemPackages = with pkgs; [
    firefox
    pavucontrol
    keepassxc
    vulkan-tools
    qpwgraph
    btrfs-assistant
    kdePackages.filelight
    fsearch
    mpv
    obs-studio
    kdePackages.krdc
    remmina
  ] ++ (with self.packages.${pkgs.stdenv.hostPlatform.system}; [
    sable-client-electron
  ]);
}
