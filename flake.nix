{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
    continuwuity.url = "git+https://forgejo.ellis.link/continuwuation/continuwuity?ref=main&rev=2c7233812b6838a6942ca57d5304ed843ce2bb05";
    copyparty.url = "github:9001/copyparty";
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
      continuwuity,
      agenix,
      ...
    }@inputs:
    {
      # NixOS installer for Raspberry Pi 5
      packages.aarch64-linux.default = nixos-raspberrypi.installerImages.rpi5;

      devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
        packages =
          with nixpkgs.legacyPackages.x86_64-linux;
          [
            nixos-rebuild-ng
            nixos-install
            nixos-install-tools
          ]
          ++ [ agenix.packages.x86_64-linux.default ];
      };

      nixosConfigurations = {
        jvyden-pi5 = nixos-raspberrypi.lib.nixosSystem {
          specialArgs = inputs;
          modules = [ ./machines/jvyden-pi5/machine.nix ];
        };
        jvyden-thinkpad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = inputs;
          modules = [ ./machines/jvyden-thinkpad/machine.nix ];
        };
      };
    };
}
