{
  config,
  agenix,
  pkgs,
  ...
}:

{
  imports = [
    agenix.nixosModules.default
  ];

  age.secrets.password = {
    file = ../secrets/password.age;
  };

  system.stateVersion = "25.11";
  time.timeZone = "America/New_York";

  boot.tmp.useTmpfs = true;

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

  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
    };
  };
  programs.ssh.setXAuthLocation = true;
  security.polkit.enable = true;
  security.sudo.enable = true;

  # mdns and other network discovery stuff
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
  services.lldpd.enable = true;

  # nix config
  nix = {
    settings = {
      trusted-users = [ "jvyden" ];
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

  # networking
  networking = {
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

  # common CLI programs
  environment.systemPackages = with pkgs; [
    tree
    htop
    btop
    fastfetch
    nano
    agenix-cli
    lsof
    tmux
    file
    usbutils
    pciutils
    lshw
    killall
    git
    net-tools
  ];
}
