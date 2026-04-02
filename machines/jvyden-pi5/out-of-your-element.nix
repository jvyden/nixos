{ self, pkgs, ... }:

let
  dataDir = "/var/lib/out-of-your-element";
  registrationFile = "${dataDir}/registration.yaml";
in
{
  systemd.services.out-of-your-element = {
    wantedBy = [ "multi-user.target" ];
    description = "Matrix-Discord bridge with modern features.";
    wants = [
      "network-online.target"
      "continuwuity.service"
    ];
    after = [
      "network-online.target"
      "continuwuity.service"
    ];

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RuntimeMaxSec = "4h";

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

      ExecStart = "${self.packages.${pkgs.stdenv.hostPlatform.system}.out-of-your-element}/bin/out-of-your-element";
    };
  };

  environment.systemPackages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.out-of-your-element ];
}
