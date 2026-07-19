{ config, lib, pkgs, ... }:
{
  boot.initrd.kernelModules = [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
    "kvmfr"
   ];

   boot.kernelParams = [
     "amd_iommu=on"
     "vfio-pci.ids=10de:1201,10de:0e0c"
     "pcie_acs_override=downstream,multifunction"
     "kvmfr.static_size_mb=64"
   ];

   boot.extraModulePackages = [ config.boot.kernelPackages.kvmfr ];

   services.udev.packages = lib.singleton (pkgs.writeTextFile
     {
       name = "kvmfr";
       text = ''
         SUBSYSTEM=="kvmfr", GROUP="kvm", MODE="0660", TAG+="uaccess"
       '';
       destination = "/etc/udev/rules.d/70-kvmfr.rules";
     }
   );

   virtualisation.libvirtd.qemu = {
     verbatimConfig = ''
       namespaces = []
       cgroup_device_acl = [
         "/dev/null", "/dev/full", "/dev/zero",
         "/dev/random", "/dev/urandom",
         "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
         "/dev/rtc","/dev/hpet", "/dev/vfio/vfio",
         "/dev/kvmfr0"
       ]
     '';
   };

   environment.systemPackages = with pkgs; [
     looking-glass-client
   ];
}
