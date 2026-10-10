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
    rev = "a5032776731a458f4678ea5f0ab6514374fde121";
    ref = "v${version}";
  };

  patches = [
    ./dont-specify-additional-creators.patch
  ];

  npmDepsHash = "sha256-L0BeeoWqV9DfH9oUBFQPjocfuy9zkAUJ/IxjF2vDoTk=";
  dontNpmBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    makeWrapper ${nodejs}/bin/node $out/bin/out-of-your-element \
      --add-flags "$out/lib/node_modules/out-of-your-element/start.js"

    makeWrapper ${nodejs}/bin/node $out/bin/out-of-your-element-setup \
      --add-flags "$out/lib/node_modules/out-of-your-element/scripts/setup.js"
  '';
}
