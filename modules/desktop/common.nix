{
  pkgs,
  self,
  config,
  ...
}:
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
      insertNameservers = config.networking.nameservers;
    };
    useDHCP = false;
    dhcpcd.enable = false;
  };

  services.upower.enable = true;
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

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
  };

  programs.virt-manager.enable = true;

  environment.systemPackages =
    with pkgs;
    [
      firefox
      pavucontrol
      keepassxc
      vulkan-tools
      qpwgraph
      btrfs-assistant
      kdePackages.filelight
      fsearch
      mpv
      kdePackages.krdc
      remmina
      xauth # we primarily prefer wayland but this is useful for X forwarding
      cmus
      copyparty # for partyfuse utility
      mesa-demos
      thunderbird
      wl-clipboard
    ]
    ++ (with self.packages.${pkgs.stdenv.hostPlatform.system}; [
      sable-client-electron
    ]);

  fonts = {
    enableDefaultPackages = true;

    packages =
      with pkgs;
      [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        unifont
        unifont_upper
        unifont-csur
        liberation_ttf
        fira-code
        fira-code-symbols
        ibm-plex
        ubuntu-sans
        ubuntu-sans-mono
        ubuntu-classic
        roboto
        source-sans
        font-awesome
      ]
      ++ (with self.packages.${pkgs.stdenv.hostPlatform.system}; [
        more-and-less-perfect-dos-vga
      ]);
  };
}
