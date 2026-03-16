{ self, pkgs, ... }:

let
  dataDir = "/var/lib/viaproxy";
in
{
  networking.firewall.allowedTCPPorts = [25565];

  systemd.services.viaproxy = {
    wantedBy = [ "multi-user.target" ];
    description = "Standalone proxy which allows players to join EVERY Minecraft server version";
    wants = [
      "network-online.target"
    ];
    after = [
      "network-online.target"
    ];

    serviceConfig = {
      Type = "simple";
      Restart = "always";

      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;

      DynamicUser = true;
      PrivateTmp = true;
      WorkingDirectory = dataDir;
      StateDirectory = baseNameOf dataDir;
      UMask = "0027";

      ExecStart = "${self.packages.${pkgs.stdenv.hostPlatform.system}.viaproxy}/bin/viaproxy";
    };
  };

  environment.systemPackages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.viaproxy ];
}
