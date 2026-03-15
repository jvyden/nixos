{ nix-minecraft, ... }:
{
  imports = [
    nix-minecraft.nixosModules.minecraft-servers
    ./beta.nix
    ./viaproxy.nix
  ];
  nixpkgs.overlays = [ nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
  };
}
