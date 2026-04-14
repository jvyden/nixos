{ config, continuwuity, pkgs, lib, ... }:

{
  imports = [
    ./out-of-your-element.nix
  ];

  age.secrets."continuwuity-turn-secret" = {
    file = ../../secrets/continuwuity-turn-secret.age;
    mode = "770";
    owner = "continuwuity";
    group = "continuwuity";
  };

  services.matrix-continuwuity = {
    enable = true;
    package =
      continuwuity.outputs.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings = {
      global = {
        server_name = "jvyden.xyz";
        address = [ "0.0.0.0" ];
        port = [ 8008 ];
        allow_announcements_check = true;

        cache_capacity_modifier = 0.5;
        dns_cache_entries = 0;
        ip_lookup_strategy = 1;

        max_request_size = 104857600;

        trusted_servers = [ "matrix.org" ];
        query_trusted_key_servers_first = false;
        federation_timeout = 120;

        allow_registration = false;
        allow_public_room_directory_over_federation = true;
        allow_device_name_federation = true;
        allow_inbound_profile_lookup_federation_requests = false;
        allow_unstable_room_versions = true;

        allow_local_presence = true;
        allow_incoming_presence = true;
        allow_outgoing_presence = true;
        presence_idle_timeout_s = 180;
        presence_offline_timeout_s = 900;
        typing_federation_timeout_s = 15;
        presence_timeout_remote_users = false;

        turn_uris = [
          "turn:jvyden.xyz?transport=udp"
          "turn:jvyden.xyz?transport=tcp"
          "turns:jvyden.xyz?transport=udp"
          "turns:jvyden.xyz?transport=tcp"
        ];
        turn_secret_file = "${config.age.secrets."continuwuity-turn-secret".path}";
        turn_ttl = 86400;

        media_startup_check = true;

        admin_execute = [ "server admin-notice continuwuity has (re)started!" ];
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

  systemd.services.continuwuity.serviceConfig = {
    Restart = lib.mkForce "always";
    RuntimeMaxSec = lib.mkForce "4h";
  };
}
