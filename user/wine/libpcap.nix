{ pkgsi686Linux
, fetchurl
, autoPatchelfHook
, makeWrapper
, lib
, callPackage
, ...
} @ args:

pkgsi686Linux.stdenv.mkDerivation rec {
  pname = "libpcap";
  version = "1.10.3";
  src = fetchurl {
    url = "https://media.githubusercontent.com/media/zglinus-for-nix/nix-source/master/Applications/wine/lib32-libpcap-1.10.3-1-x86_64.tar.gz";
    sha256 = "sha256-FpWuKuLLJTmIO8gpOJmfRkKU5YIf7y6mrJmrPMGap/A=";
  };

  # autoPatchelfHook 可以自动修改二进制文件
  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  buildInputs = [
    pkgsi686Linux.dbus
    pkgsi686Linux.libnl
  ];

  outputs = [ "out" ];

  unpackPhase = ''
    tar xf ${src}

  '';

  installPhase = ''
    mkdir -p $out
    ls
    cp -r lib32*/usr/lib32 $out/lib
    ln -s $out/lib/libpcap.so.1.10.3 $out/lib/libpcap.so.0.8
  '';
}
