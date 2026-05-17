{ stdenvNoCC, fetchurl, ... }:

# https://laemeur.sdf.org/fonts/
stdenvNoCC.mkDerivation {
  pname = "more-and-less-perfect-dos-vga-ttf";
  version = "1.0";

  srcs = [
    (fetchurl {
      url = "https://laemeur.sdf.org/fonts/MorePerfectDOSVGA.ttf";
      hash = "sha256-97DQdPCKur54H45t4YH6rtQX0/7jFow6vDwXeqv3is0=";
    })
    (fetchurl {
      url = "https://laemeur.sdf.org/fonts/LessPerfectDOSVGA.ttf";
      hash = "sha256-5ylbGFiljfs8mFYvsREusFPwTzBBe/w/ECuvnZEYHHM=";
    })
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -pv $out/share/fonts/truetype
    cp -v $srcs $out/share/fonts/truetype

    runHook postInstall
  '';
}
