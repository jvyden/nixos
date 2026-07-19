{ ... }:
{
  imports = [
    ../../modules/common.nix
    ../../modules/home.nix
    ../../modules/boot-limine.nix
    ../../modules/ld.nix
    ../../modules/hardware/nvidia.nix
    ../../modules/hardware/bluetooth.nix
    ../../modules/desktop/common.nix
    ../../modules/desktop/no-sleep.nix
    ../../modules/workloads/gaming.nix
    ../../modules/workloads/emu.nix
    ../../modules/workloads/distrobox.nix
    ../../modules/workloads/dev.nix
    ../../modules/workloads/vr.nix
    ../../modules/workloads/waydroid.nix
    ../../modules/workloads/virt.nix
    ./virt-gpu.nix
    ./kernel.nix
    ./wifi-ap.nix
    ./watch.nix
  ];

  hardware.enableRedistributableFirmware = true; # for wifi chip :3

  boot.loader.limine = {
    enableEditor = true;
  };

  # Networking setup
  networking = {
    hostName = "the-overcooler";
    defaultGateway = "10.0.0.1";
    interfaces.enp6s0.ipv4.addresses = [
      {
        address = "10.0.0.100";
        prefixLength = 24;
      }
    ];
  };

  # Disk setup
  services.btrfs = {
    autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = [ "/" ];
    };
  };

  # Disk setup
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/E083-0A4A";
      fsType = "vfat";
      options = [
        "noatime"
        "noauto"
        "x-systemd.automount"
        "x-systemd.idle-timeout=1min"
      ];
    };
    "/" = {
      device = "/dev/disk/by-uuid/84797aba-67e8-48d0-9e0c-774ac0142582";
      fsType = "btrfs";
      options = [
        "subvol=nixos"
        "compress=zstd:7"
        "noatime"
      ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/84797aba-67e8-48d0-9e0c-774ac0142582";
      fsType = "btrfs";
      options = [
        "subvol=nix"
        "compress=zstd:7"
        "noatime"
      ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/84797aba-67e8-48d0-9e0c-774ac0142582";
      fsType = "btrfs";
      options = [
        "subvol=home"
        "compress=zstd:7"
      ];
    };
    "/work" = {
      device = "/dev/disk/by-uuid/84797aba-67e8-48d0-9e0c-774ac0142582";
      fsType = "btrfs";
      options = [
        "subvol=work"
        "compress=zstd:7"
      ];
    };
    "/data" = {
      device = "/dev/disk/by-uuid/84797aba-67e8-48d0-9e0c-774ac0142582";
      fsType = "btrfs";
      options = [
        "subvol=data"
        "compress=zstd:7"
      ];
    };
  };
}
