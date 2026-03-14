{...}:
{
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
    ./beta.nix
  ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
  }
}