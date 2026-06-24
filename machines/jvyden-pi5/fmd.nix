# ref'd from Version33
# https://github.com/Version33/HomeServer/blob/25775d6e4cb678fd4c2ff45324b0371d1d2b308c/modules/services/fmd.nix#L27

{ nixpkgs, config, ... }:
{
  age.secrets."fmd-env" = {
    file = ../../secrets/fmd-env.age;
    mode = "770";
    owner = "fmd-server";
    group = "fmd-server";
  };

  networking.firewall.interfaces."wg0".allowedTCPPorts = [ 8004 ];

  users.users.fmd-server = {
    isSystemUser = true;
    group = "fmd-server";
    home = "/var/lib/fmd-server";
    createHome = true;
  };

  users.groups.fmd-server = { };

  systemd.services.fmd-server = {
    description = "FMD Server - FindMyDevice location server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    unitConfig = {
      StartLimitInterval = 0;
    };
    serviceConfig = {
      Type = "simple";
      User = "fmd-server";
      Group = "fmd-server";
      ExecStart = "${nixpkgs.legacyPackages.aarch64-linux.fmd-server}/bin/fmd-server serve";
      Restart = "on-failure";
      RestartSec = "5s";

      StateDirectory = "fmd-server";
      WorkingDirectory = "/var/lib/fmd-server";

      Environment = [
        "FMD_DATABASEDIR=/var/lib/fmd-server"
        "FMD_PORTINSECURE=8004"
        "FMD_REMOTEIPHEADER=CF-Connecting-IP"
      ];

      EnvironmentFile = config.age.secrets."fmd-env".path;

      # Hardening
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ReadWritePaths = "/var/lib/fmd-server";
      PrivateTmp = true;
      PrivateDevices = true;
      ProtectClock = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectControlGroups = true;
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
        "AF_UNIX"
      ];
      RestrictNamespaces = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      RemoveIPC = true;
      SystemCallArchitectures = "native";
    };
  };
}
