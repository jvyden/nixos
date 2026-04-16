{
  lib,
  buildNpmPackage,
  makeWrapper,
  nodejs,
  ...
}:

buildNpmPackage rec {
  pname = "out-of-your-element";
  version = "3.5.1";

  src = builtins.fetchGit {
    url = "https://gitdab.com/cadence/out-of-your-element/";
    rev = "4698835549def91b4546f977cc7aad404b610668";
    ref = "v${version}";
  };

  npmDepsHash = "sha256-EYxJi6ObJQOLyiJq4C3mV6I62ns9l64ZHcdoQxmN5Ao=";
  dontNpmBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    makeWrapper ${nodejs}/bin/node $out/bin/out-of-your-element \
      --add-flags "$out/lib/node_modules/out-of-your-element/start.js"

    makeWrapper ${nodejs}/bin/node $out/bin/out-of-your-element-setup \
      --add-flags "$out/lib/node_modules/out-of-your-element/scripts/setup.js"
  '';
}
