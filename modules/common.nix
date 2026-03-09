{ config, agenix, ... }:

{
  imports = [
    agenix.nixosModules.default
  ];

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
  system.autoUpgrade = {
    enable = true;
    runGarbageCollection = true;
    # flake = "git+file:///home/jvyden/nixos";
    # NOTE: when making new machines, ensure root can connect to jvyden@jvyden-pi5.local autonomously
    flake = "git+ssh://jvyden@jvyden-pi5.local/~/nixos";
    flags = [
      "--verbose"
      "--print-build-logs"
      "--commit-lock-file"
      "--accept-flake-config"
    ];
    dates = "02:00";
    randomizedDelaySec = "5min";
  };
}
