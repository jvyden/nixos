# { lib, pkgs, gradle_9, makeWrapper, stdenv, fetchFromGitHub, ... }:
{
  lib,
  pkgs,
  makeWrapper,
  stdenv,
  fetchurl,
}:
let
  commitHash = "82f64be84fb66a7645310012093be0c13417e94c";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "viaproxy";
  version = "3.4.9";

  src = fetchurl {
    url = "https://github.com/ViaVersion/ViaProxy/releases/download/v${finalAttrs.version}/ViaProxy-${finalAttrs.version}.jar";
    sha256 = "sha256-ufwzxMinzVPl5l5xmM80+hjDgdjjXU0qa6T/xBVfx1k=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    makeWrapper ${pkgs.jdk25}/bin/java $out/bin/viaproxy \
      --add-flags "-jar ${finalAttrs.src}" \
      --add-flags "cli"
  '';

  # below is an attempt at building with gradle.
  # can't get it to work. ill just download the binary release for now

  # src = fetchFromGitHub {
  #   owner = "ViaVersion";
  #   repo = "ViaProxy";
  #   tag = "v${finalAttrs.version}";
  #   hash = "sha256-zdbNXSgM2zIVNkxJvnmJkqLR0U9jJNMWu585N4/UDrI=";
  # };

  # patches = [ ./stub-commit-hash.patch ];

  # postPatch = ''
  #   substituteInPlace buildSrc/src/main/groovy/base.fill-build-constants.gradle \
  #     --replace "COMMIT" "${commitHash}"
  # '';

  # nativeBuildInputs = [
  #   gradle_9
  #   pkgs.git
  #   pkgs.jdk17
  #   pkgs.jdk25
  #   makeWrapper
  # ];

  # env.JAVA_HOME = pkgs.jdk25;
  # gradleFlags = [
  #   "--info"
  #   "--no-configuration-cache"
  # ];

  # # gradleUpdateTask = "nixDownloadDeps jar";

  # # if the package has dependencies, mitmCache must be set
  # mitmCache = gradle_9.fetchDeps {
  #   pkg = finalAttrs.finalPackage;
  #   data = ./deps.json;
  #   silent = false;
  #   useBwrap = false;
  # };

  # # this is required for using mitm-cache on Darwin
  # __darwinAllowLocalNetworking = true;

  # meta.sourceProvenance = with lib.sourceTypes; [
  #   fromSource
  #   binaryBytecode # mitm cache
  # ];
})
