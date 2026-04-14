{ lib, ... }:

let
  coreCount = 4;
in
{
  # increase max buffer sizes for sockets in the kernel
  boot.kernel.sysctl = {
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_max" = 16777216;
  };

  networking.nameservers = lib.mkForce [ "127.0.0.1" ];
  services.unbound = {
    enable = true;
    settings = {
      server = {
        # Continuwuity recommendations: https://continuwuity.org/advanced/dns.html#unbound
        rrset-cache-size = "128M"; # unbound docs recommend msg-cache-size*2 for rrset
        msg-cache-size = "64M";
        discard-timeout = 4800;

        # Unbound performance tuning: https://unbound.docs.nlnetlabs.nl/en/latest/topics/core/performance.html
        num-threads = coreCount;
        outgoing-range = 1024 / coreCount - 50;
        so-reuseport = true;
        so-rcvbuf = "8M";
        so-sndbuf = "8M";

        # Serve stale entries: https://unbound.docs.nlnetlabs.nl/en/latest/topics/core/serve-stale.html
        serve-expired = true;
        serve-expired-ttl = 1800; # 30 minutes, in seconds. this is low on purpose to allow hs IP changes to not be a problem for too long.
        serve-expired-client-timeout = 1500; # 1.5 seconds, in milliseconds
      };
    };
  };
}