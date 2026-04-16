# heavily references vesktop package: https://github.com/NixOS/nixpkgs/blob/4b6fd8e8882c7a5dca301f6b1d3cdcd9316f033f/pkgs/by-name/ve/vesktop/package.nix
{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  nodejs,
  electron_40,
  jq,
  makeDesktopItem,
  copyDesktopItems,
  imagemagick,
  withTTS ? true,
  withMiddleClickScroll ? false,
  ...
}:
let
  electron = electron_40;
in
buildNpmPackage (finalAttrs: {
  pname = "sable-client-electron";
  version = "git";

  src = fetchFromGitHub {
    owner = "7w1";
    repo = "Sable-Client-Electron";
    rev = "8751d73cc6c53fb7abdf5b99232e541166944ff8";
    hash = "sha256-oI8dr8Ud5+by2oJYUZ+OS/HDFkBIcyuqDZ59M5hM118=";
  };

  npmDepsHash = "sha256-XawYnHHuAS4HbsQYKhRQ0qPeZom7KB/2sw4GMFq5C9s=";

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  prePatch = ''
    # workaround for https://github.com/electron/electron/issues/31121
    sed -i "s#process\.resourcesPath#'$out/opt/Sable-Client-Electron/resources'#g" \
      main.js

    # workaround sable using __dirname in the wrong spot for now
    sed -i "s#__dirname#'$out/opt/Sable-Client-Electron/resources'#g" \
      main.js
  '';

  # electron builds must be writable
  preBuild = ''
    # Validate electron version matches upstream package.json
    if [ "`jq -r '.devDependencies.electron' < package.json | cut -d. -f1 | tr -d '^'`" != "${lib.versions.major electron.version}" ]
    then
      echo "ERROR: electron version mismatch between package.json and nixpkgs"
      exit 1
    fi
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    cp -r ${electron.dist}/Electron.app .
    chmod -R u+w Electron.app
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist
  '';

  nativeBuildInputs = [
    nodejs
    jq
    makeWrapper
    copyDesktopItems
    imagemagick # for icon generation
  ];

  buildPhase = ''
    runHook preBuild

    npm exec electron-builder --offline -- \
      --dir \
      -c.asarUnpack="**/*.node" \
      -c.electronDist=${if stdenv.hostPlatform.isDarwin then "." else "electron-dist"} \
      -c.electronVersion=${electron.version} \
      ${lib.optionalString stdenv.hostPlatform.isDarwin "-c.mac.identity=null"} # disable code signing on macos, https://github.com/electron-userland/electron-builder/blob/77f977435c99247d5db395895618b150f5006e8f/docs/code-signing.md#how-to-disable-code-signing-during-the-build-process-on-macos

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/opt/Sable-Client-Electron
    cp -r dist/*unpacked/resources $out/opt/Sable-Client-Electron/

    for i in 16 24 48 64 96 128 256 512; do
      mkdir -p $out/share/icons/hicolor/''${i}x''${i}/apps
      magick icon.png -background none -resize ''${i}x''${i} $out/share/icons/hicolor/''${i}x''${i}/apps/sable.png
    done
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv dist/mac*/Sable-Client-Electron.app $out/Applications/Sable-Client-Electron.app
  ''
  + ''
    runHook postInstall
  '';

  postFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      makeWrapper ${electron}/bin/electron $out/bin/sable-client-electron \
        --add-flags $out/opt/Sable-Client-Electron/resources/app.asar \
        --set ELECTRON_FORCE_IS_PACKAGED true \
        ${lib.strings.optionalString withTTS ''
          --run 'if [[ "''${NIXOS_SPEECH:-default}" != "False" ]]; then NIXOS_SPEECH=True; else unset NIXOS_SPEECH; fi' \
          --add-flags "\''${NIXOS_SPEECH:+--enable-speech-dispatcher}" \
        ''} \
        ${lib.optionalString withMiddleClickScroll "--add-flags \"--enable-blink-features=MiddleClickAutoscroll\""} \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      makeWrapper $out/Applications/Sable-Client-Electron.app/Contents/MacOS/Sable-Client-Electron $out/bin/sable-client-electron
    '';

  desktopItems = lib.optional stdenv.hostPlatform.isLinux (makeDesktopItem {
    name = "sable-client-electron";
    desktopName = "Sable";
    exec = "sable-client-electron %U";
    icon = "sable";
    startupWMClass = "Sable";
    genericName = "Internet Messenger";
    keywords = [
      "sable"
      "matrix"
      "electron"
    ];
    categories = [
      "Network"
      "InstantMessaging"
      "Chat"
    ];
  });
})
