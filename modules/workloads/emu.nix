{
  pkgs,
  ...
}:

{
  networking.firewall.allowedUDPPorts = [ 8086 ];
  environment.systemPackages = with pkgs; [
    _86box-with-roms
    vde2
  ];
}
