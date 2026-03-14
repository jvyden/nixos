{ self, pkgs, ... }:

{
  services.minecraft-servers.servers.beta = {
    enable = true;
    package = self.packages.${pkgs.stdenv.hostPlatform.system}.uberbukkit;
  };
}
