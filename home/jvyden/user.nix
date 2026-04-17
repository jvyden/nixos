{ ... }:
{
  home.stateVersion = "25.11";
  programs.bash.enable = true;
  imports = [
    ./cli.nix
    ./plasma.nix
  ];
}
