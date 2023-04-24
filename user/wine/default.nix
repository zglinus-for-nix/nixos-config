{ pkgsi686Linux
, fetchurl
, autoPatchelfHook
, lib
, callPackage
, ...
} @ args:

let pkgs = import <nixpkgs> { system = "i686-linux"; }; in

pkgsi686Linux.stdenv.mkDerivation rec {
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
  freetype = fetchurl {
    url = "http://ftp.cn.debian.org/debian/pool/main/f/freetype/libfreetype6_2.12.1+dfsg-4_i386.deb";
    sha256 = "sha256-xHurVoqKLpXy2EX7aWpbPrSWUtmx/f0ULFN0nxV5u/4=";
  };

  # autoPatchelfHook 可以自动修改二进制文件
  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    (callPackage ./openldap-2_4.nix { })
    (callPackage ./vkd3d.nix { })
    (callPackage ./libpcap.nix { })
  ] ++ (with pkgsi686Linux; [
    libxml2
    libusb1
    brotli
    libpng
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
  ]);

  unpackPhase = ''
    ar x ${src}
    tar xf data.tar.xz
    ar x ${src32}
    tar xf data.tar.xz  
    ar x ${freetype}
    tar xf data.tar.xz  
  '';

  installPhase = ''
    mkdir -p $out
    cp -r usr/* $out
    mv $out/lib/i386-linux-gnu/libfreetype.so.* $out/lib/
    sed -i "s|/usr/|$out/|g" $out//bin/*
  '';

  meta = {
    architecture = [ "i686" ];
  };
}
