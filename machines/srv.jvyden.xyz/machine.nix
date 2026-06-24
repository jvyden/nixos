{ ... }:
{
  imports = [
    ../../modules/common.nix
    ../../modules/boot-limine.nix
  ];

  # Networking setup
  networking = {
    hostName = "srv.jvyden.xyz";
    interfaces.ens3.useDHCP = true;
  };

  # Disk setup
  services.btrfs = {
    autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = ["/"];
    };
  };

  # try to use noatime when possible
  fileSystems = {
    "/boot/firmware" = {
      device = "/dev/disk/by-uuid/433D-E290";
      fsType = "vfat";
      options = [
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
      ];
    };
  };
}
