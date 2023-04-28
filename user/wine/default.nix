{ pkgsi686Linux
, fetchurl
, autoPatchelfHook
, lib
, callPackage
, zstd
, makeWrapper
, ...
} @ args:

let
  libraries = (with pkgsi686Linux; [
    alsa-lib
    alsa-plugins
    glibc
    glib
    libgphoto2
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    mpg123
    openal
    pulseaudio
    systemd
    libusb1
    xorg.libX11
    xorg.libXext
    libxml2
    ocl-icd
    ncurses
    cups
    dbus
    fontconfig
    freetype
    wine
    gsmlib
    libkrb5
    libjpeg
    unixODBC
    libpng
    sane-backends
    libtiff
    libv4l
    libsForQt5.qt5.qtwayland
    p11-kit
    libunistring
    nettle
    gmp
  ]);
in

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
  lib32_openldap24 = fetchurl {
    url = "https://community-packages.deepin.com/deepin/pool/main/o/openldap/libldap-2.4-2_2.4.47+dfsg.4-1+eagle_i386.deb";
    sha256 = "sha256-dGhIoB37mIqa/SVuKl57cwnD5l+WTkeD/zfP/Zi/xo4=";
  };
  lib32_cyrus_sasl = fetchurl {
    url = "https://community-packages.deepin.com/deepin/pool/main/c/cyrus-sasl2/libsasl2-2_2.1.27.1-1+dde_i386.deb";
    sha256 = "sha256-jxtl2xkjnAcmial3XaJpnK2iPplzjFsB0T4pPPiZvb0=";
  };
  vkd3d_32 = fetchurl {
    url = "https://media.githubusercontent.com/media/zglinus-for-nix/nix-source/master/Applications/wine/lib32-vkd3d-1.6-1-x86_64.tar.gz";
    sha256 = "sha256-ZqdvIJkNDh7OwkAAgmn5JWSN7dNlJq490koq26fgkTg=";
  };
  libpcap_32 = fetchurl {
    url = "https://media.githubusercontent.com/media/zglinus-for-nix/nix-source/master/Applications/wine/lib32-libpcap-1.10.3-1-x86_64.tar.gz";
    sha256 = "sha256-FpWuKuLLJTmIO8gpOJmfRkKU5YIf7y6mrJmrPMGap/A=";
  };

  lib32_libcapi = fetchurl {
    url = "http://ftp.cn.debian.org/debian/pool/main/libc/libcapi20-3/libcapi20-3_3.27-3_i386.deb";
    sha256 = "sha256-JISOiGL1C+X8FtvrWqwSCDswf7kAutepOJHVMBPpqHs=";
  };
  lib32_libglu1 = fetchurl {
    url = "https://mirror.sjtu.edu.cn/ubuntu/pool/main/libg/libglu/libglu1-mesa_9.0.0-2.1_i386.deb";
    sha256 = "sha256-5dmGQnsIaP2o2xMTAJIDVXq1FpYiezjqnFo2PA7MzLw=";
  };
  # lib32_libosmesa = fetchurl {
  #   url = "http://security.ubuntu.com/ubuntu/pool/main/m/mesa/libosmesa6_19.2.8-0ubuntu0~18.04.2_i386.deb";
  #   sha256 = "sha256-EbFtC9fHQQWeMRoaZHkZjlE7mLMhSy8M3PAJrq1+57I=";
  # };
  lib32_libsdl2 = fetchurl {
    url = "https://mirror.sjtu.edu.cn/ubuntu/pool/main/libs/libsdl2/libsdl2-2.0-0_2.0.20+dfsg-2build1_i386.deb";
    sha256 = "sha256-gUVDcVsAlgR4idJ4H46H+B3nBGP3Q4NKUlEWJGuyZsI=";
  };
  lib32_libxcursor = fetchurl {
    url = "https://mirror.sjtu.edu.cn/ubuntu/pool/main/libx/libxcursor/libxcursor1_1.2.0-2_i386.deb";
    sha256 = "sha256-4cFH1S+sLBiLXI4MWQNTATR3DgMxiu+6BVxh0q2aHes=";
  };
  lib32_libxfixes = fetchurl {
    url = "http://ftp.cn.debian.org/debian/pool/main/libx/libxfixes/libxfixes3_6.0.0-2_i386.deb";
    sha256 = "sha256-NVOXd9iB+/9vk6cVcfsGWTLvob8jksw6GbM9+ZY1Ikk=";
  };
  lib32_libxi6 = fetchurl {
    url = "https://mirror.sjtu.edu.cn/ubuntu/pool/main/libx/libxi/libxi6_1.7.6-1_i386.deb";
    sha256 = "sha256-gzDO3+kKj7xE8X2nVlriPGnsFEKRHvy35Dej/X1HdSg=";
  };
  lib32_libxinerama = fetchurl {
    url = "https://mirror.sjtu.edu.cn/ubuntu/pool/main/libx/libxinerama/libxinerama1_1.1.3-1_i386.deb";
    sha256 = "sha256-rLxIPOl1dNpcIk+fnVT8kz7cFeaKCGfehxKwaGyvbZ4=";
  };
  lib32_libxrandr = fetchurl {
    url = "https://mirror.sjtu.edu.cn/ubuntu/pool/main/libx/libxrandr/libxrandr2_1.4.2-1_i386.deb";
    sha256 = "sha256-dfaAAYm8Sjc/Zw52JfDjiBD6BZrUk6WJRs82Z5Y/8LE=";
  };
  lib32_libxrender = fetchurl {
    url = "https://mirror.sjtu.edu.cn/ubuntu/pool/main/libx/libxrender/libxrender1_0.9.10-1.1_i386.deb";
    sha256 = "sha256-iOEnXeKl69fqlifO3QxplD8pwgCGBxKbV2BOgoyHTtM=";
  };
  lib32_libxslt = fetchurl {
    url = "https://mirror.sjtu.edu.cn/ubuntu/pool/main/libx/libxslt/libxslt1.1_1.1.28-2.1_i386.deb";
    sha256 = "sha256-8643pneT8pAmFyop+y5PnKzGc5I7rg4IHNXuk1AqrNA=";
  };
  lib32_libxxf86vml = fetchurl {
    url = "https://mirror.sjtu.edu.cn/ubuntu/pool/main/libx/libxxf86vm/libxxf86vm1_1.1.3-1_i386.deb";
    sha256 = "sha256-WCZX0CqK9eRPW4VCLHzMFAfXTmxn56dlyd9BhbCbR84=";
  };
  lib32_libguntls30 = fetchurl {
    url = "https://mirror.sjtu.edu.cn/ubuntu/pool/main/g/gnutls28/libgnutls30_3.7.8-5ubuntu1_i386.deb";
    sha256 = "sha256-2YTPnykg1X0EhvP/VIUIQAFBtAu5NgSmoORxmYsOtUc=";
  };
  lib32_libidn2 = fetchurl {
    url = "https://mirror.sjtu.edu.cn/ubuntu/pool/main/libi/libidn2/libidn2-0_2.2.0-2_i386.deb";
    sha256 = "sha256-fsAiQjFBgvgBZcEwBblskbVDbOuJSq29KBvhreACddM=";
  };
  lib32_libtasn1 = fetchurl {
    url = "https://mirror.sjtu.edu.cn/ubuntu/pool/main/libt/libtasn1-6/libtasn1-6_3.4-3_i386.deb";
    sha256 = "sha256-vm3Eik0GRQlEVWTOPMuqbpGqVFhgrmAzZcgGbjpFSZ0=";
  };
  lib32_liblcms2 = fetchurl {
    url = "https://mirror.sjtu.edu.cn/ubuntu/pool/main/l/lcms2/liblcms2-2_2.9-4_i386.deb";
    sha256 = "sha256-P79RWalHxNdkEggwTYychuuI4CabUZDWgN7w7hUsaHc=";
  };

  lib32_udis86 = fetchurl {
    url = "https://community-packages.deepin.com/deepin/pool/non-free/u/udis86/udis86_1.72-4_i386.deb";
    sha256 = "sha256-7IdOzfEvldY0wDik3SkVlRquCXU/S6ulCyB00VTgQ3Q=";
  };

  dontWrapQtApps = 1;
  # autoPatchelfHook 可以自动修改二进制文件
  nativeBuildInputs = [ autoPatchelfHook zstd makeWrapper ];
  buildInputs = [
    libraries
    pkgsi686Linux.libnl
  ];


  unpackPhase = ''
    ar x ${src}
    tar xf data.tar.xz
    ar x ${src32}
    tar xf data.tar.xz  
    ar x ${lib32_cyrus_sasl}
    tar xf data.tar.xz  
    ar x ${lib32_libcapi}
    tar xf data.tar.xz  
    ar x ${lib32_libglu1}
    tar xf data.tar.xz  
    ar x ${lib32_libsdl2}
    tar xf data.tar.xz  
    ar x ${lib32_libxcursor}
    tar xf data.tar.xz  
    ar x ${lib32_libxfixes}
    tar xf data.tar.xz   
    ar x ${lib32_libxi6}
    tar xf data.tar.xz   
    ar x ${lib32_libxinerama}
    tar xf data.tar.xz   
    ar x ${lib32_libxrandr}
    tar xf data.tar.xz   
    ar x ${lib32_libxrender}
    tar -I zstd -xf data.tar.zst  
    ar x ${lib32_libxslt}
    tar xf data.tar.xz  
    ar x ${lib32_libxxf86vml}
    tar xf data.tar.xz  
    ar x ${lib32_libguntls30}
    tar -I zstd -xf data.tar.zst  
    ar x ${lib32_libidn2}
    tar xf data.tar.xz   
    ar x ${lib32_libtasn1}
    tar xf data.tar.xz   
    ar x ${lib32_liblcms2}
    tar xf data.tar.xz  
    ar x ${lib32_openldap24}
    tar xf data.tar.xz  
    ar x ${lib32_udis86}
    tar xf data.tar.xz  
    tar xf ${vkd3d_32}
    tar xf ${libpcap_32}
  '';

  installPhase = ''
    mkdir -p $out/lib/
    mkdir -p $out/bin/
    mkdir -p $out/exec/
    cp -r usr/* $out
    cp -r lib32*/usr/lib32/* $out/lib/i386-linux-gnu
    ln -s $out/lib/i386-linux-gnu/libpcap.so.1.10.3 $out/lib/i386-linux-gnu/libpcap.so.0.8
    mv $out/bin/* $out/exec
    sed -i "s|/usr/|$out/|g" $out//exec/deepin-wine*
    for var in `ls $out/exec/`;
      do makeWrapper $out/exec/$var $out/bin/$var \
        --argv0 "$var" \
        --prefix LD_LIBRARY_PATH : "$out/lib:${lib.makeLibraryPath libraries}"
    done
  '';

  meta = {
    architecture = [ "i686" ];
  };
}
