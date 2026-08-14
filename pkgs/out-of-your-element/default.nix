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
    rev = "b3ef973568cd6bee817a8bc6368160bb39e7784b";
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
