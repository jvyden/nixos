{ ... }:

{
  services.immich = {
    enable = true;
    port = 2283;
    host = "0.0.0.0";
    openFirewall = true;
    accelerationDevices = null;
    database = {
      enable = true;
      createDB = false; # bullshit required for migration from old db
    };
  };

  # bullshit required for migration from old db
  services.postgresql = {
    ensureDatabases = ["immich"];
    ensureUsers = [
      {
        name = "immich";
        ensureDBOwnership = true;
        ensureClauses = {
          login = true;
          superuser = true;
        }
      }
    ];
  };
}