{ resonite, pkgs, config, ... }:
{
  imports = [
    resonite.nixosModules.resonite-headless
  ];

  age.secrets."resonite-credentials" = {
    file = ../../secrets/resonite/credentials.age;
    mode = "700";
    owner = "resonite";
    group = "resonite";
  };

  networking.firewall.allowedUDPPorts = [6969];

  services.resonite = {
    enable = true;
    credentialsFile = config.age.secrets."resonite-credentials".path;
    extraArgs = "-Verbose -DisablePlatformInterfaces -NeverSaveDash -NeverSaveSettings";
    settings = { # https://wiki.resonite.com/Headless_server_software/Configuration_file
      startWorlds = [
        {
          isEnabled = true;
          sessionName = "NixOS Headless Test";
          loadWorldPresetName = "Grid";
          accessLevel = "Anyone";
          forcePort = 6969;
          defaultUserRoles = {
            "jvyden" = "Admin";
          };
        }
      ];
    };
  };
}