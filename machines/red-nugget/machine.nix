{ ... }:
{
  imports = [
    ../../modules/common.nix
    ../../modules/common-cli.nix
    ../../modules/network.nix
    ../../modules/battery.nix
    ../../modules/boot-limine.nix
    ../../modules/common-desktop.nix
    ../../modules/kde.nix
    ../../modules/workloads/gaming.nix
  ];

  # Networking setup
  networking = {
    hostName = "red-nugget";
    interfaces.eno1.useDHCP = true;
  };

  # Disk setup
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/2E09-4834";
      fsType = "vfat";
      options = [
        "noatime"
        "noauto"
        "x-systemd.automount"
        "x-systemd.idle-timeout=1min"
      ];
    };
    "/" = {
      device = "/dev/disk/by-uuid/914ba3fa-d9a7-4bbe-b369-071507777414";
      fsType = "btrfs";
      options = [
        "subvol=nixos"
        "compress=zstd:7"
        "noatime"
      ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/914ba3fa-d9a7-4bbe-b369-071507777414";
      fsType = "btrfs";
      options = [
        "subvol=nixos/nix"
        "compress=zstd:7"
        "noatime"
      ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/914ba3fa-d9a7-4bbe-b369-071507777414";
      fsType = "btrfs";
      options = [
        "subvol=home"
        "compress=zstd:7"
        "noatime"
      ];
    };
  };
}