{ config, pkgs, continuwuity, ... }:

{
  imports = [
    ../../modules/rpi5.nix
    ../../modules/common.nix
    ../../modules/common-cli.nix
    ../../modules/home-ethernet.nix
    ./cloudflared.nix
    ./continuwuity.nix
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

  # Disk setup
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
      ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/90ae52b4-d5e8-4b80-ae84-dd534b402359";
      fsType = "btrfs";
      options = [
        "subvol=home"
        "compress=zstd:7"
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
