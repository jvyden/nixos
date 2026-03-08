{ config, ... }:

{
  age.secrets.password = {
    file = ../secrets/password.age;
  };

  system.stateVersion = "25.11";

  boot.tmp.useTmpfs = true;
  nix.settings.trusted-users = [ "jvyden" ];

  users.users.jvyden = {
    hashedPasswordFile = config.age.secrets.password.path;
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "networkmanager"
    ];
  };

  services.openssh.enable = true;
  security.polkit.enable = true;
  security.sudo.enable = true;

  # mdns
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    ipv4 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };
}
