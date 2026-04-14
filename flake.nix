{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
    # continuwuity.url = "git+https://forgejo.ellis.link/continuwuation/continuwuity?ref=main&rev=2c7233812b6838a6942ca57d5304ed843ce2bb05";
    continuwuity.url = "git+https://forgejo.ellis.link/continuwuation/continuwuity?ref=main&rev=7bbe31adeea8090e2b9b05d37dc943f12ebee004";
    copyparty.url = "github:9001/copyparty";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
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
      nix-minecraft,
      agenix,
      ...
    }@inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems f;
    in
    {
      # custom packages
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ nix-minecraft.overlays.default ];
            config.allowUnfree = true;
          };
        in
        {
          out-of-your-element = pkgs.callPackage ./pkgs/out-of-your-element { };
          uberbukkit = pkgs.callPackage ./pkgs/uberbukkit { };
          viaproxy = pkgs.callPackage ./pkgs/viaproxy { };

          # NixOS installer for Raspberry Pi 5
          aarch64-linux.default = nixos-raspberrypi.installerImages.rpi5;
        }
      );

      devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
        packages =
          with nixpkgs.legacyPackages.x86_64-linux;
          [
            nixos-rebuild-ng
            nixos-install
            nixos-install-tools
          ]
          ++ [
            agenix.packages.x86_64-linux.default
            # self.packages.x86_64-linux.out-of-your-element
          ];
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
        red-nugget = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = inputs;
          modules = [ ./machines/red-nugget/machine.nix ];
        };
      };
    };
}
