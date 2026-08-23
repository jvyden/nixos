{
  buildNpmPackage,
  makeWrapper,
  nodejs,
  ...
}:

buildNpmPackage rec {
  pname = "out-of-your-element";
  version = "git";

  src = fetchGit {
    url = "https://gitdab.com/cadence/out-of-your-element/";
    rev = "c7389ff2d6feb1c33a7f5963984c468691dc1b72";
    ref = "v${version}";
  };

  npmDepsHash = "sha256-4iJCCpw+0YEnMPBAlHx6cOSImEjjOm/fbwzPnwzQrxw=";
  dontNpmBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    makeWrapper ${nodejs}/bin/node $out/bin/out-of-your-element \
      --add-flags "$out/lib/node_modules/out-of-your-element/start.js"

    makeWrapper ${nodejs}/bin/node $out/bin/out-of-your-element-setup \
      --add-flags "$out/lib/node_modules/out-of-your-element/scripts/setup.js"
  '';
}
