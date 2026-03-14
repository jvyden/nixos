{ pkgs, ... }:


{
  services.minecraft-servers.beta = {
    enable = true;
    package = pkgs.uberbukkit;
  };
}
