{ stdenv
, fetchurl
, autoPatchelfHook
, lib
, callPackage
, libxml2
, gst_all_1
, xorg
, libusb1
, systemd
, udis86
, pulseaudio
, libgphoto2
, ocl-icd
, openal
, alsa-lib
, mpg123
, lcms2
, ...
} @ args:

let pkgs = import <nixpkgs> { system = "i686-linux"; }; in

stdenv.mkDerivation rec {
  pname = "deepin-wine";
  version = "5.0.16";
  pkgver = "5.0.16";
  pkgrel = "1";
  src = fetchurl {
    url = "https://community-store-packages.deepin.com/appstore/pool/appstore/d/deepin-wine5/deepin-wine5_${pkgver}-${pkgrel}_i386.deb";
    sha256 = "sha256-xQ9wlbqjyPn/MwrVIVxDk2Ko8+D3Yhog7OoIkOnjxiE=";
  };
  src32 = fetchurl {
    url = "https://community-store-packages.deepin.com/appstore/pool/appstore/d/deepin-wine5/deepin-wine5-i386_${pkgver}-${pkgrel}_i386.deb";
    sha256 = "sha256-6j81RDhIOg+PSOAVkFvFKkGgbW/yeRDItx8i9/siO98=";
  };

  # autoPatchelfHook 可以自动修改二进制文件
  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    libxml2
    libusb1
    systemd
    udis86
    pulseaudio
    libgphoto2
    ocl-icd
    openal
    mpg123
    lcms2
    alsa-lib
    gst_all_1.gst-plugins-base
    xorg.libX11
    (callPackage ./openldap-2_4.nix { })
    (callPackage ./vkd3d.nix { })
    (callPackage ./libpcap.nix { })
  ];

  unpackPhase = ''
    ar x ${src}
    tar xf data.tar.xz
    ar x ${src32}
    tar xf data.tar.xz

  '';

  installPhase = ''
    mkdir -p $out
    cp -r usr/* $out
    sed -i "s|/usr/|$out/|g" $out//bin/*
  '';

  meta = {
    architecture = [ "i686" ];
  };
}
