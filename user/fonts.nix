{ stdenvNoCC
, lib
, fetchurl
, ...
} @ args:

# stdenvNoCC 是一个没有编译器的打包环境，毕竟我们打包字体也用不到编译器
stdenvNoCC.mkDerivation rec {
  pname = "zglinus-s-fonts";
  version = "0.1";
  src = fetchurl {
    url = "https://media.githubusercontent.com/media/zglinus-for-nix/nix-source/master/system/fonts.tar.gz";
    sha256 = "sha256-R3w/CYM77ZJazwZyg+IFZhk0lWccLJXNpQMFUEW+zFw=";
  };

  unpackPhase = ''
   tar xzf ${src}
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/user/
    cp source/* $out/share/fonts/user/
  '';
}
