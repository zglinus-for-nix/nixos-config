{ stdenv
, fetchurl
, autoPatchelfHook
, makeWrapper
, lib
, callPackage
, ...
} @ args:

stdenv.mkDerivation rec {
  pname = "cryus-sasl2";
  version = "2.1.27.1";
  src = fetchurl {
    url = "https://community-packages.deepin.com/deepin/pool/main/c/cyrus-sasl2/libsasl2-2_2.1.27.1-1+dde_i386.deb";
    sha256 = "sha256-jxtl2xkjnAcmial3XaJpnK2iPplzjFsB0T4pPPiZvb0=";
  };

  # autoPatchelfHook 可以自动修改二进制文件
  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  outputs = [ "out" ];

  unpackPhase = ''
    ar x ${src}
    tar xf data.tar.xz

  '';

  installPhase = ''
    mkdir -p $out
    cp -r usr/* $out
    mv $out/lib/i386-linux-gnu/* $out/lib/
    rm -r $out/lib/i386-linux-gnu/
  '';
}