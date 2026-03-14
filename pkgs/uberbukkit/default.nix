{
  pkgs,
  stdenv,
  fetchurl,
  ...
}:
let
  shortVersion = "2.0.2";
in
pkgs.vanillaServers.vanilla-1_2_5.overrideAttrs
  (old: rec {
    pname = "uberbukkit";
    version = "2.0.2-241217-1442-3a5552b";

    src = fetchurl {
      url = "https://github.com/Moresteck/uberbukkit/releases/download/${version}/uberbukkit-${shortVersion}.jar";
      sha256 = "sha256-ZttLDpBgeR2SM90kdegwqem1TalBVTndzsxziusCzlA=";
    };

  })
