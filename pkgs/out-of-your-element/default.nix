{
  lib,
  buildNpmPackage,
  makeWrapper,
  nodejs,
  ...
}:

buildNpmPackage rec {
  pname = "out-of-your-element";
  version = "3.4";

  src = builtins.fetchGit {
    url = "https://gitdab.com/cadence/out-of-your-element/";
    rev = "c55e6c611585f4c1dbfd8c767e5f872fbeb0c66a";
    ref = "v${version}";
  };

  npmDepsHash = "sha256-DTKf8nNeWpV/x34aNwXCvHhfsthyYffYX2TrM/h2bfE=";
  dontNpmBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    makeWrapper ${nodejs}/bin/node $out/bin/out-of-your-element \
      --add-flags "$out/lib/node_modules/out-of-your-element/start.js"

    makeWrapper ${nodejs}/bin/node $out/bin/out-of-your-element-setup \
      --add-flags "$out/lib/node_modules/out-of-your-element/scripts/setup.js"
  '';
}
