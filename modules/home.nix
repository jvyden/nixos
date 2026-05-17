{ home-manager, plasma-manager, ... }:
{
  imports = [
    home-manager.nixosModules.home-manager
  ];

  # home-manager base config
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [ plasma-manager.homeModules.plasma-manager ];

    backupFileExtension = "bak";

    users.jvyden = ../home/jvyden/user.nix;
  };
}
