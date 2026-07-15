{ config, lib, ... }:

{
  # key configuration
  age.secrets."xyztunnel-key-private" = {
    file = ../../secrets/xyztunnel-key-private.age;
  };

  age.secrets."xyztunnel-key-pub" = {
    file = ../../secrets/xyztunnel-key-pub.age;
  };

  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [
        "fd31:bf08:57cb::2/64"
        "192.168.1.2/24"
      ];
      dns = [ "127.0.0.1" ];
      privateKeyFile = config.age.secrets."xyztunnel-key-private".path;
      peers = [
        {
          # TODO: obscure pubkey and rotate
          publicKey = "nD5TtvhI6sW/XfYT0JnF4EUDT4E555gYn4sGt9hD81I=";
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
          endpoint = "jvyden.xyz:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  # A couple tweaks to improve reliability
  systemd.services.wg-quick-wg0 = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    unitConfig = {
      StartLimitInterval = lib.mkForce 0;
    };
    serviceConfig = {
      Restart = lib.mkForce "always";
      RestartSec = lib.mkForce 5;
    };
  };
}
