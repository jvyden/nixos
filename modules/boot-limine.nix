{ pkgs, ... }:
{
  boot.loader.limine.enable = true;

  environment.systemPackages = with pkgs; [
    efibootmgr
  ];
}
