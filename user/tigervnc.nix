{ stdenv
, fetchurl
, autoPatchelfHook
, makeWrapper
, lib
, callPackage
, xorg
, libX11
, fltk
, zlib
, gnutls
, ...
} @ args:

let
  libraries = [
    libX11
    fltk
    zlib
    gnutls
  ] ++ (with xorg; [
    libXrender
    libXi
  ]);
in

stdenv.mkDerivation rec {
  pname = "tigervnc";
  version = "1.11";
  src = fetchurl {
    url = "http://ftp.de.debian.org/debian/pool/main/t/tigervnc/tigervnc-viewer_1.11.0+dfsg-2+deb11u1_amd64.deb";
    sha256 = "sha256-GW6On8bHLjvSgSeAcHi7UfnHwtYe0lS5PybROv8Tyt0=";
  };

  buildInputs = libraries;

    # autoPatchelfHook 可以自动修改二进制文件
  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  unpackPhase = ''
    ar x ${src}
    tar xf data.tar.xz
  '';

  installPhase = ''
    mkdir -p $out
    mv usr/* $out/
    sed -i "
    s|/usr/bin/xtigervncviewer|$out/bin/xtigervncviewer|
    " "$out/share/applications/xtigervncviewer.desktop"
  '';
}
