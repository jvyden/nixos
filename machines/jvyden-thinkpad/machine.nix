{ ... }:
{
  imports = [
    ../../modules/common.nix
    ../../modules/home.nix
    ../../modules/hardware/battery.nix
    ../../modules/hardware/fingerprint.nix
    ../../modules/hardware/bluetooth.nix
    ../../modules/boot-limine.nix
    ../../modules/desktop/common.nix
    ../../modules/workloads/gaming.nix
    ../../modules/workloads/emu.nix
    ../../modules/workloads/distrobox.nix
    ./resonite.nix
  ];

  hardware.enableRedistributableFirmware = true; # for wifi chip :3

  # Networking setup
  networking = {
    hostName = "jvyden-thinkpad";
    interfaces.enp0s25.useDHCP = true;
  };

  # Disk setup
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/2EF1-C330";
      fsType = "vfat";
      options = [
        "noatime"
        "noauto"
        "x-systemd.automount"
        "x-systemd.idle-timeout=1min"
      ];
    };
    "/" = {
      device = "/dev/disk/by-uuid/fa7d1ff8-c278-4017-8f4f-7c9b05ff9ee5";
      fsType = "btrfs";
      options = [
        "subvol=nixos"
        "compress=zstd:7"
        "noatime"
      ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/fa7d1ff8-c278-4017-8f4f-7c9b05ff9ee5";
      fsType = "btrfs";
      options = [
        "subvol=nixos/nix"
        "compress=zstd:7"
        "noatime"
      ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/fa7d1ff8-c278-4017-8f4f-7c9b05ff9ee5";
      fsType = "btrfs";
      options = [
        "subvol=home"
        "compress=zstd:7"
        "noatime"
      ];
    };
  };
}
