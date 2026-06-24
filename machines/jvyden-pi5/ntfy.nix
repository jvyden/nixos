{...}:
{
  networking.firewall.interfaces."wg0".allowedTCPPorts = [ 2586 ];

  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://push.jvyden.xyz";
      listen-http = "0.0.0.0:2586";
      behind-proxy = true;

      enable-login = true;
      enable-signup = true;
      require-login = true;

      attachment-file-size-limit = "100M";
    };
  };
}
