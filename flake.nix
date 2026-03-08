{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
  };

  nixConfig = {
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
    extra-platforms = [
      "aarch64-linux"
    ];
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-raspberrypi,
      ...
    }@inputs:
    {
      packages.aarch64-linux.default =
        let
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            crossSystem = {
              config = "aarch64-unknown-linux-gnu";
            };
          };
        in
        nixos-raspberrypi.installerImages.rpi5;

      nixosConfigurations = {
        jvyden-pi5 = nixos-raspberrypi.lib.nixosSystem {
          specialArgs = inputs;
          modules = [
            (
              { ... }:
              {
                imports = with nixos-raspberrypi.nixosModules; [
                  raspberry-pi-5.base
                  raspberry-pi-5.display-vc4
                ];
              }
            )
            (
              { ... }:
              {
                networking.hostName = "jvyden-pi5";
                nix.settings.trusted-users = [ "jvyden" ];
                users.users.jvyden = {
                  initialPassword = "weed";
                  isNormalUser = true;
                  extraGroups = [
                    "wheel"
                    "video"
                    "audio"
                    "networkmanager"
                  ];
                };

                services.openssh.enable = true;
                security.polkit.enable = true;
                security.sudo.enable = true;
              }
            )
            (
              { ... }:
              {
                # boot.supportedFileSystems = [ "btrfs" ];
                fileSystems = {
                  "/boot" = {
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
            )
          ];
        };
      };
    };
}
