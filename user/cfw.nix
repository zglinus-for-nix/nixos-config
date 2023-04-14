{ stdenv
, lib
, autoPatchelfHook
, fetchurl
, xorg
, gtk3
, pango
, at-spi2-atk
, nss
, libdrm
, alsa-lib
, mesa
, udev
, libappindicator
, imagemagick
, nodePackages
, makeDesktopItem
}:

let
  desktopItem = makeDesktopItem {
    name = "clash-for-windows";
    desktopName = "Clash for Windows";
    comment = "A Windows/macOS/Linux GUI based on Clash and Electron";
    icon = "clash-for-windows";
    exec = "cfw";
    categories = [ "Network" ];
  };
in
stdenv.mkDerivation rec {
  pname = "cfw";
  version = "0.20.20";
  src = fetchurl{
    url = "https://github.com/Fndroid/clash_for_windows_pkg/releases/download/0.20.20/Clash.for.Windows-0.20.20-x64-linux.tar.gz";
    sha256 = "sha256-WfG4HuN+gLE60HdSXb0xXi//qUzX7DqnrP9H6QKE3TQ=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    imagemagick
    nodePackages.asar
  ];

  buildInputs = [
    gtk3
    pango
    at-spi2-atk
    nss
    libdrm
    alsa-lib
    mesa
  ] ++ (with xorg; [
    libXext
    libXcomposite
    libXrandr
    libxshmfence
    libXdamage
  ]);

  runtimeDependencies = [
    libappindicator
    udev
  ];

  installPhase = ''
    mkdir app-extract
    asar extract resources/app.asar app-extract
    echo "11"
    sed -i "
      s|/usr/bin/pkexec|/run/wrappers/bin/pkexec|
      s|/bin/bash|/usr/bin/env bash|
    " "app-extract/node_modules/@vscode/sudo-prompt/index.js"
    rm -rf resources/app.asar
    echo "gone!!"
    asar pack app-extract/ resources/app.asar
    echo "pack"
    mkdir -p "$out/opt"
    cp -r . "$out/opt/clash-for-windows"

    mkdir -p "$out/bin"
    ln -s "$out/opt/clash-for-windows/cfw" "$out/bin/cfw"

    mkdir -p "$out/share/applications"
    install "${desktopItem}/share/applications/"* "$out/share/applications/"

    raw_icon=app-extract/dist/electron/static/imgs/icon_512.png
    icon_dir="$out/share/icons/hicolor/512x512/apps"
    mkdir -p "$icon_dir"
    cp app-extract/dist/electron/static/imgs/icon_512.png "$icon_dir/clash-for-windows.png"
  '';

}
