{ stdenv
, fetchurl
, autoPatchelfHook
, makeWrapper
, lib
, callPackage
, gnutls
, ...
} @ args:

stdenv.mkDerivation rec {
  pname = "libldep";
  version = "2.4.47";
  src = fetchurl {
    url = "https://community-packages.deepin.com/deepin/pool/main/o/openldap/libldap-2.4-2_2.4.47+dfsg.4-1+eagle_i386.deb";
    sha256 = "sha256-dGhIoB37mIqa/SVuKl57cwnD5l+WTkeD/zfP/Zi/xo4=";
  };

  # autoPatchelfHook 可以自动修改二进制文件
  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    gnutls
    (callPackage ./cryus-sasl2.nix { })
  ];

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
