{ pinetime-heartrate-server, ... }:
{
  imports = [
    pinetime-heartrate-server.nixosModules.default
  ];

  services.pinetimeHeartrate = {
    enable = true;
    host = "0.0.0.0";
    openFirewall = true;
  };
}
