{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      agenix,
      ...
    }@inputs:
    {
      # NixOS installer for Raspberry Pi 5
      packages.aarch64-linux.default = nixos-raspberrypi.installerImages.rpi5;

      devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
        packages = with nixpkgs.legacyPackages.x86_64-linux; [
          nixos-rebuild-ng
        ]
        ++ [ agenix.packages.x86_64-linux.default ];
      };

      nixosConfigurations = {
        jvyden-pi5 = nixos-raspberrypi.lib.nixosSystem {
          specialArgs = inputs;
          modules = [
            agenix.nixosModules.default
            ./modules/common.nix
            ./modules/rpi5.nix
            ./modules/common-cli.nix
            (
              { ... }:
              {
                networking = {
                    hostName = "jvyden-pi5";
                    defaultGateway = "10.0.0.1";
                    nameservers = [ "1.1.1.1" "1.0.0.1" ];
                    interfaces.end0.ipv4.addresses = [
                        {
                            address = "10.0.0.228";
                            prefixLength = 24;
                        }
                    ];
                };
              }
            )
            (
              { ... }:
              {
                boot.loader.raspberry-pi.bootloader = "kernel";
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
            )
          ];
        };
      };
    };
}
