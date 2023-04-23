{ pkgsi686Linux
, fetchurl
, autoPatchelfHook
, makeWrapper
, lib
, callPackage
, ...
} @ args:

pkgsi686Linux.stdenv.mkDerivation rec {
  pname = "libvkd3d";
  version = "1.6.1";
  src = fetchurl {
    url = "https://media.githubusercontent.com/media/zglinus-for-nix/nix-source/master/Applications/wine/lib32-vkd3d-1.6-1-x86_64.tar.gz";
    sha256 = "sha256-ZqdvIJkNDh7OwkAAgmn5JWSN7dNlJq490koq26fgkTg=";
  };

  # autoPatchelfHook 可以自动修改二进制文件
  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  outputs = [ "out" ];

  unpackPhase = ''
    tar xf ${src}

  '';

  installPhase = ''
    mkdir -p $out
    ls
    cp -r lib32*/usr/lib32 $out/lib
  '';
}