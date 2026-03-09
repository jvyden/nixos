{ copyparty, config, pkgs, ... }:

{
  imports = [
    copyparty.nixosModules.default
  ];
  nixpkgs.overlays = [ copyparty.overlays.default ];

  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 0;
  networking.firewall.allowedTCPPorts = [80 443 21 69];

  age.secrets."copyparty-jvyden-password" = {
    file = ../../secrets/copyparty/jvyden-password.age;
    mode = "770";
    owner = "copyparty";
    group = "copyparty";
  };

  age.secrets."copyparty-localguest-password" = {
    file = ../../secrets/copyparty/localguest-password.age;
    mode = "770";
    owner = "copyparty";
    group = "copyparty";
  };

  services.copyparty = {
    enable = true;
    package = copyparty.outputs.packages.${pkgs.stdenv.hostPlatform.system}.copyparty-full;
    user = "copyparty";
    group = "copyparty";

    settings = {
      z = true;
      z-on = ["10.0.0.0/24" "10.1.0.0/24"];
      usernames = true;
      ups-when = true;
      ups-who = 1;
      p = [80 443];
      ftp = 21;
      tftp = 69;
      ah-alg = "argon2";
      shr = "/shares";
      og = true;
      og-ua = "(Discord|Twitter|Slack)bot";
      xff-src = "lan";
      xff-hdr = "cf-connecting-ip";
      rproxy = 1;
      e2dsa = true;
      e2ts = true;
      magic = true;
      ipu = "10.0.0.0/24=localguest";
      # ipu = "10.1.0.0/24=localguest"; // TODO: report that I can't set multiple ipu rules
      # hist = "/var/lib/copyparty/hist";
    };

    accounts = {
      jvyden.passwordFile = config.age.secrets."copyparty-jvyden-password".path;
      localguest.passwordFile = config.age.secrets."copyparty-localguest-password".path;
    };

    groups = {
      super = ["jvyden"];
    };

    volumes = {
      "/" = {
        path = "/var/lib/copyparty/data";
        access = {
          A = "@super";
          r = "*";
          rwmd = "@acct";
        };
      };
      "/localguest" = {
        path = "/var/lib/copyparty/localguest";
        access = {
          A = "@super";
          rwmd = "@acct";
        };
      };
      "/obsidian" = {
        path = "/var/lib/copyparty/obsidian";
        access = {
          A = "jvyden";
        };
        flags = {
          d2d = true;
        };
      };
    };
  };
}
