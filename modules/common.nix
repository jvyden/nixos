{ ... }:

{
  system.stateVersion = "25.11";
  boot.tmp.useTmpfs = true;
  nix.settings.trusted-users = [ "jvyden" ];
  users.users.jvyden = {
    initialPassword = "weed";
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
  networking.firewall.allowedUDPPorts = [ 5353 ];
  systemd.network.networks = {
    "99-ethernet-default-dhcp".networkConfig.MulticastDNS = "yes";
  };
}
