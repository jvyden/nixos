{ pkgs, ... }:
{
  boot.loader.limine = {
    enable = true;
    efiSupport = true;
    biosSupport = false;
    maxGenerations = 5;
  };

  environment.systemPackages = with pkgs; [
    efibootmgr
    limine-full
  ];
}
