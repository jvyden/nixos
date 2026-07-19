{ pkgs, ... }:
{
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };

  users.users.jvyden.extraGroups = [ "libvirtd" ];

  # for libvirt networking
  networking.firewall.trustedInterfaces = [ "virbr0" ];
  environment.systemPackages = with pkgs; [
    dnsmasq
  ];
}
