{ pkgsi686Linux
, fetchurl
, autoPatchelfHook
, lib
, callPackage
, ...
} @ args:

let pkgs = import <nixpkgs> { system = "i686-linux"; }; in

pkgsi686Linux.stdenv.mkDerivation rec {
  pname = "deepin-wine-helper";
  version = "5.1.45-1";
  src = fetchurl {
    url = "https://community-store-packages.deepin.com/appstore/pool/appstore/d/deepin-wine-helper/deepin-wine-helper_${version}_i386.deb";
    sha256 = "sha256-SoRetzFvq0Q3o0YmHtVpZSOQO28NAIVXNhJPfnrJGhM=";
  };
  # autoPatchelfHook 可以自动修改二进制文件
  nativeBuildInputs = [ autoPatchelfHook ];

  unpackPhase = ''
    ar x ${src}
    tar xf data.tar.xz
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r opt/deepinwine/tools/* $out/bin
    sed -i "s|/opt/apps/.*/files|\$\{OUTPATH\}/files|g" $out//bin/*
  '';

  meta = {
    architecture = [ "i686" ];
  };
}
