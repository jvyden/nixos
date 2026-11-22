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
    rev = "b2553b8aa3d6d518d7958dbcb181be9b3f77fba6";
    ref = "v${version}";
  };

  patches = [
    # ./dont-specify-additional-creators.patch
  ];

  npmDepsHash = "sha256-a/4bZ1tKpI28ndOqdzsB+PsrPpnJTlBygOkMjNSmPY4=";
  dontNpmBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    makeWrapper ${nodejs}/bin/node $out/bin/out-of-your-element \
      --add-flags "$out/lib/node_modules/out-of-your-element/start.js"

    makeWrapper ${nodejs}/bin/node $out/bin/out-of-your-element-setup \
      --add-flags "$out/lib/node_modules/out-of-your-element/scripts/setup.js"
  '';
}
