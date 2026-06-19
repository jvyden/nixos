{...}:
{
  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://push.jvyden.xyz";
      listen-http = "127.0.0.1:2586";
      behind-proxy = true;

      enable-login = true;
      enable-signup = true;
      require-login = true;

      attachment-file-size-limit = "100M";
    };
  };
}
