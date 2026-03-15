{ lib, pkgs, gradle_9, makeWrapper, stdenv, fetchFromGitHub, ... }:
let
  commitHash = "82f64be84fb66a7645310012093be0c13417e94c";
in
stdenv.mkDerivation(finalAttrs: {
  pname = "viaproxy";
  version = "3.4.9";

  # package depends on git information, can't use fetchFromGitHub which uses a git archive
  src = fetchFromGitHub {
    owner = "ViaVersion";
    repo = "ViaProxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zdbNXSgM2zIVNkxJvnmJkqLR0U9jJNMWu585N4/UDrI=";
  };

  patches = [./stub-commit-hash.patch];

  postPatch = ''
    substituteInPlace buildSrc/src/main/groovy/base.fill-build-constants.gradle \
      --replace "COMMIT" "${commitHash}"
  '';

  nativeBuildInputs = [
    gradle_9
    pkgs.git
    pkgs.jdk17
    pkgs.jdk25
    makeWrapper
  ];

  env.JAVA_HOME = pkgs.jdk25;
  gradleFlags = ["--info" "--no-configuration-cache"];

  # gradleUpdateTask = "nixDownloadDeps jar";

  # if the package has dependencies, mitmCache must be set
  mitmCache = gradle_9.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
    silent = false;
    useBwrap = false;
  };

  # this is required for using mitm-cache on Darwin
  __darwinAllowLocalNetworking = true;

  meta.sourceProvenance = with lib.sourceTypes; [
    fromSource
    binaryBytecode # mitm cache
  ];
})
