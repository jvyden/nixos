{
  pkgs,
  ...
}:

let
  _86box_overlay = (
    self: super: {
      _86box-with-roms = super._86box-with-roms.overrideAttrs (prev: {
        version = "git";
        src = pkgs.fetchFromGitHub {
          owner = "86Box";
          repo = "86Box";
          rev = "53fd57d980f9f6da7f0a23cdb6ce385171e92a41";
          hash = "sha256-sKOrrhWtwgia/jhqzdmSXyI+H2cePQGS5MI8Rfc2gqo=";
        };
        patches = [ ];
        passthru.roms = pkgs.fetchFromGitHub {
          owner = "86Box";
          repo = "roms";
          rev = "27ce81b34e37a96a25232984d67389b9206ff91a";
          hash = "sha256-+c7bw3mGCcAELC1GjFa7OUe11kQuuS2BRr+wZdTayEk=";
        };
        nativeBuildInputs = prev.nativeBuildInputs ++ [
          pkgs.vde2
          pkgs.vulkan-headers
        ];
      });
    }
  );
in
{
  networking.firewall.allowedUDPPorts = [ 8086 ];
  nixpkgs.overlays = [ _86box_overlay ];
  environment.systemPackages = with pkgs; [
    _86box-with-roms
    vde2
  ];
}
