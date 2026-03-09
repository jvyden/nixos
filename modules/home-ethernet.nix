{...}:
{
  networking = {
    defaultGateway = "10.0.0.1";
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    firewall = {
      enable = true;
      allowPing = true;
      rejectPackets = true;
    };
  };
}