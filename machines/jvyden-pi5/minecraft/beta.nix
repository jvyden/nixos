{ self, pkgs, ... }:

{
  services.minecraft-servers.servers.beta = {
    enable = true;
    package = self.packages.${pkgs.stdenv.hostPlatform.system}.uberbukkit;
    serverProperties = {
      online-mode = true;
      view-distance = 15;
      white-list = true;
    };
    files = {
      "white-list.txt" = {
        value = [
          "jvyden420"
          "lyristhekitori"
        ];
      };
      "ops.txt" = {
        value = [
          "jvyden420"
          "lyristhekitori"
        ];
      };
      "bukkit.yml" = {
        value = {
          settings = {
            update-folder = "update";
            spawn-radius = 0;
            permissions-file = "permissions.yml";
          };
          database = {
            password = "walrus";
            driver = "org.sqlite.JDBC";
            isolation = "SERIALIZABLE";
            url = "jdbc:sqlite:{DIR}{NAME}.db";
            username = "bukkit";
          };
          aliases = {
            icanhasbukkit = ["version"];
          };
        };
      };
    };
  };
}
