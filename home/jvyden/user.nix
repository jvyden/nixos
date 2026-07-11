{ lib, ... }:
{
  home.stateVersion = "25.11";
  programs.bash.enable = true;
  imports = [
    ./cli.nix
    ./plasma/plasma.nix
    ./zed.nix
    ./konsole/konsole.nix
    ./gpg.nix
  ];

  assertions = lib.mkForce [];
}
