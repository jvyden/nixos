{ config, pkgs, continuwuity, ... }:

{
  # Networking setup
  networking = {
    hostName = "jvyden-pi5";
    defaultGateway = "10.0.0.1";
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    interfaces.end0.ipv4.addresses = [
      {
        address = "10.0.0.228";
        prefixLength = 24;
      }
    ];
  };

  # SERVICES
  # Cloudflare Ingress
  age.secrets."jvyden-pi5-cloudflared" = {
    file = ../secrets/jvyden-pi5-cloudflared.age;
  };
  services.cloudflared = {
    enable = false; # FIXME
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
  # Continuwuity
  age.secrets."continuwuity-turn-secret" = {
    file = ../secrets/continuwuity-turn-secret.age;
  };
  services.matrix-continuwuity = {
    enable = true;
    package = continuwuity.outputs.packages.${pkgs.stdenv.hostPlatform.system}.continuwuity-all-features-bin;
    settings = {
      global = {
        server_name = "jvyden.xyz";
        address = [ "0.0.0.0" ];
        port = [ 8008 ];
        allow_announcements_check = true;

        cache_capacity_modifier = 0.5;
        dns_cache_entries = 8192;
        ip_lookup_strategy = 1;

        max_request_size = 104857600;

        trusted_servers = [ "matrix.org" ];
        query_trusted_key_servers_first = true;
        federation_timeout = 120;

        allow_registration = false;
        allow_public_room_directory_over_federation = true;
        allow_device_name_federation = true;
        allow_inbound_profile_lookup_federation_requests = false;
        allow_unstable_room_versions = true;

        turn_uris = [
          "turn:jvyden.xyz?transport=udp"
          "turn:jvyden.xyz?transport=tcp"
          "turns:jvyden.xyz?transport=udp"
          "turns:jvyden.xyz?transport=tcp"
        ];
        turn_secret_file = "${config.age.secrets."continuwuity-turn-secret".path}";
        turn_ttl = 86400;

        media_startup_check = true;

        admin_execute = [ "server admin-notice continuwuity has started!" ];
        admin_execute_errors_ignore = true;
        admin_room_tag = "m.server_notice";
        admin_room_notices = true;

        well_known = {
          client = "https://matrix.jvyden.xyz";
          server = "matrix.jvyden.xyz:443";
          support_page = "mailto:jvyden@jvyden.xyz";
          support_email = "jvyden@jvyden.xyz";
          support_mxid = "@jvyden:jvyden.xyz";
          support_role = "m.role.admin";

          rtc_focus_server_urls = [
            {
              type = "livekit";
              livekit_service_url = "https://livekit.jvyden.xyz";
            }
          ];
        };
      };
    };
  };

  # Disk setup
  fileSystems = {
    "/boot/firmware" = {
      device = "/dev/disk/by-uuid/433D-E290";
      fsType = "vfat";
      options = [
        "noatime"
        "noauto"
        "x-systemd.automount"
        "x-systemd.idle-timeout=1min"
      ];
    };
    "/" = {
      device = "/dev/disk/by-uuid/90ae52b4-d5e8-4b80-ae84-dd534b402359";
      fsType = "btrfs";
      options = [
        "subvol=nixos"
        "compress=zstd:7"
      ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/90ae52b4-d5e8-4b80-ae84-dd534b402359";
      fsType = "btrfs";
      options = [
        "subvol=home"
        "compress=zstd:7"
      ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/90ae52b4-d5e8-4b80-ae84-dd534b402359";
      fsType = "btrfs";
      options = [
        "subvol=nixos/nix"
        "compress=zstd:7"
        "noatime"
      ];
    };
  };
}
