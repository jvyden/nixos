{ pkgs, config, ... }:

let
  dataDir = "/var/lib/vpstunnel";
in
{
  # SSH key configuration
  age.secrets."vpstunnel-key-private" = {
    file = ../../secrets/vpstunnel-key-private.age;
    mode = "700";
    owner = "vpstunnel";
    group = "vpstunnel";
  };

  age.secrets."vpstunnel-key-pub" = {
    file = ../../secrets/vpstunnel-key-pub.age;
    mode = "700";
    owner = "vpstunnel";
    group = "vpstunnel";
  };

  # systemd configuration
  users.groups.vpstunnel = {};
  users.users.vpstunnel = {
    group = "vpstunnel";
    isSystemUser = true;
    home = dataDir;
  };

  systemd.services.vpstunnel = {
    description = "SOCKS5 tunnel to VPS";
    wantedBy = [ "multi-user.target" ];
    wants = [
      "network-online.target"
    ];
    after = [
      "network-online.target"
    ];

    preStart = ''
      mkdir -p ${dataDir}/.ssh
      ${pkgs.openssh}/bin/ssh-keyscan -t ecdsa jvyden.xyz > ${dataDir}/.ssh/known_hosts
      chmod -R 700 ${dataDir}/.ssh
    '';

    unitConfig = {
      # prevent lennart poettering moments
      # me when i design an *init* system that has the default behavior of *stopping* services
      StartLimitInterval = 0;
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.openssh}/bin/ssh -v -D 1080 -C -N -i ${config.age.secrets."vpstunnel-key-private".path} vpstunnel@jvyden.xyz";
      Restart = "always";
      RestartSec = 5;

      User = "vpstunnel";
      Group = "vpstunnel";

      # hardening
      ProtectSystem = "strict";
      PrivateTmp = true;
      PrivateDevices = true;
      ProtectKernelTunables = true;
      ProtectControlGroups = true;
      RestrictSUIDSGID = true;
      PrivateMounts = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectHostname = true;
      ProtectClock = true;
      ProtectProc = "invisible";
      ProcSubset = "pid";
      RestrictNamespaces = true;
      RemoveIPC = true;
      UMask = "0077";
      NoNewPrivileges = true;
      LockPersonality = true;
      RestrictRealtime = true;

      WorkingDirectory = dataDir;
      StateDirectory = baseNameOf dataDir;
      StateDirectoryMode = "0700";
    };
  };

  # TODO: find proxy that can handle failover.
  # or honestly, i can probably just build one.

  # services._3proxy = {
  #   enable = true;
  #   extraConfig = ''
  #     parent 1000 socks5 127.0.0.1 1081
  #   '';
  #   services = [
  #     {
  #       type = "socks";
  #       bindPort = 1080;
  #       auth = ["none"];
  #     }
  #   ];
  # };

  # services.squid = {
  #   enable = true;
  #   proxyAddress = "127.0.0.1";
  #   proxyPort = 3128;

  #   extraConfig = ''
  #     acl LOCAL src 127.0.0.0/8
  #     http_access allow LOCAL

  #     prefer_direct off
  #   '';
  # };
}
