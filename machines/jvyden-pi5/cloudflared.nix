{ config, ... }:

{
  age.secrets."jvyden-pi5-cloudflared" = {
    file = ../../secrets/jvyden-pi5-cloudflared.age;
  };

  services.cloudflared = {
    enable = true;
    tunnels."58bbed97-af54-45de-adff-d582ca4be8f9" = {
      credentialsFile = "${config.age.secrets."jvyden-pi5-cloudflared".path}";
      ingress = {
        "files.jvyden.xyz" = {
          service = "http://127.0.0.1:80";
        };
        "matrix.jvyden.xyz" = {
          service = "http://127.0.0.1:8008";
        };
        "ooye.jvyden.xyz" = {
          service = "http://127.0.0.1:6693";
        };
      };
      default = "http_status:404";
    };
  };
}
