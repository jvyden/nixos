{
  buildNpmPackage,
  makeWrapper,
  nodejs,
  ...
}:

buildNpmPackage rec {
  pname = "out-of-your-element";
  version = "3.6.0";

  src = fetchGit {
    url = "https://gitdab.com/cadence/out-of-your-element/";
    rev = "b5768697644ef64717641693e20fc730604fa7b6";
    ref = "v${version}";
  };

  npmDepsHash = "sha256-h1mmE0/+Y7SBwnI0vaYvV+KqRDJGzwJvDUOkigzHcOY=";
  dontNpmBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    makeWrapper ${nodejs}/bin/node $out/bin/out-of-your-element \
      --add-flags "$out/lib/node_modules/out-of-your-element/start.js"

    makeWrapper ${nodejs}/bin/node $out/bin/out-of-your-element-setup \
      --add-flags "$out/lib/node_modules/out-of-your-element/scripts/setup.js"
  '';
}
