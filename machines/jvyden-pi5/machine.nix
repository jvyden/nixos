{ config, pkgs, continuwuity, ... }:

{
  imports = [
    ../../modules/rpi5.nix
    ../../modules/common.nix
    ../../modules/common-cli.nix
    ../../modules/home-ethernet.nix
    ./cloudflared.nix
    ./continuwuity.nix
    ./copyparty.nix
    ./postgres.nix
    ./immich.nix
    ./minecraft/minecraft.nix
  ];

  # Networking setup
  networking = {
    hostName = "jvyden-pi5";
    interfaces.end0.ipv4.addresses = [
      {
        address = "10.0.0.228";
        prefixLength = 24;
      }
    ];
  };

  # apply some extra features since we're both constrained on memory and constrained on how much we should be writing
  # i don't want to kill my sd card :c
  boot.kernel.sysctl."vm.swappiness" = 20;
  services.journald = {
    storage = "volatile";
    extraConfig = ''
      RuntimeMaxUse=64M
    '';
  };

  # Disk setup
  # try to use noatime when possible
  fileSystems = {
    "/boot/firmware" = {
      device = "/dev/disk/by-uuid/433D-E290";
      fsType = "vfat";
      options = [
        "noatime"
        "noauto"
        "x-systemd.automount"
        "x-systemd.idle-timeout=1min"
      ];
    };
    "/" = {
      device = "/dev/disk/by-uuid/90ae52b4-d5e8-4b80-ae84-dd534b402359";
      fsType = "btrfs";
      options = [
        "subvol=nixos"
        "compress=zstd:7"
        "noatime"
      ];
    };
    "/var/log" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = ["size=64M"];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/90ae52b4-d5e8-4b80-ae84-dd534b402359";
      fsType = "btrfs";
      options = [
        "subvol=home"
        "compress=zstd:7"
        "noatime"
      ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/90ae52b4-d5e8-4b80-ae84-dd534b402359";
      fsType = "btrfs";
      options = [
        "subvol=nixos/nix"
        "compress=zstd:7"
        "noatime"
      ];
    };
  };
}
