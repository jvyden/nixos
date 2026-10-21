{ config, ... }:

{
  networking.firewall.allowedTCPPorts = [ 29316 ];

  services.maubot = {
    enable = true;
    settings = {
      server = {
        hostname = "0.0.0.0";
        port = 29316;
        public_url = "https://mau.jvyden.xyz";
      };
      homeservers = {
        "matrix.org" = {
          url = "https://matrix-client.matrix.org";
        };
        "jvyden.xyz" = {
          url = "http://127.0.0.1:8008";
        };
      };
      admins = import ../../../secrets/matrix/maubot-admins.nix;
    };
    plugins = with config.services.maubot.package.plugins; [
      github
      echo
      sed
      join
    ];
  };

  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];
}
