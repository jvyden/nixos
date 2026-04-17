{ config, agenix, home-manager, ... }:

{
  imports = [
    agenix.nixosModules.default
    home-manager.nixosModules.home-manager
  ];

  age.secrets.password = {
    file = ../secrets/password.age;
  };

  system.stateVersion = "25.11";
  time.timeZone = "America/New_York";

  boot.tmp.useTmpfs = true;
  nix.settings.trusted-users = [ "jvyden" ];

  users.mutableUsers = false;

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

  #nix config
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    optimise = {
      automatic = true;
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  # keep us up to date
  services.fwupd.enable = true;

  # home-manager base config
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.jvyden = ../home/jvyden/user.nix;
    backupFileExtension = "bak";
  };
}
