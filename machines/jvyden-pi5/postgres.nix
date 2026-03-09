{ pkgs, ... }:

let
  postgresPkg = pkgs.postgresql_18;
in
{
  environment.systemPackages = [postgresPkg];

  services.postgresql = {
    enable = true;
    package = postgresPkg;
  };
}