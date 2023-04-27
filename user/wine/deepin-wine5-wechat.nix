{ pkgsi686Linux
, fetchurl
, autoPatchelfHook
, makeWrapper
, lib
, callPackage
, pkgs
, bash
, p7zip
, coreutils
, zstd
, ...
} @ args:

pkgsi686Linux.stdenv.mkDerivation rec {
  pname = "deepin-wine-wechat";
  version = "3.5.0.46";
  src = fetchurl {
    url = "https://com-store-packages.uniontech.com/appstore/pool/appstore/c/com.qq.weixin.deepin/com.qq.weixin.deepin_3.4.0.38deepin6_i386.deb";
    sha256 = "sha256-bZjto1n7+MS4k7rhXN2mBZDtfT1ABvmXeuQLxje2Srk=";
  };

  font = fetchurl {
    url = "https://media.githubusercontent.com/media/zglinus-for-nix/nix-source/master/Applications/wine/fake_simsun.tar.gz";
    sha256 = "sha256-lWAhpcLVl8D6ui0Zn2CmG7L3NP6k+TBwItquzSQ9DS0=";
  };

  mmmojo = fetchurl {
    url = "https://media.githubusercontent.com/media/zglinus-for-nix/nix-source/master/Applications/wine/mmmojo.tar.gz";
    sha256 = "sha256-+51Ks0SQi6uuatLUXxtUVRQnlBk23ZVXrS+JkWLhcmA=";
  };

  runfile = fetchurl {
    url = "https://media.githubusercontent.com/media/zglinus-for-nix/nix-source/master/Applications/wine/wechat.tar.gz";
    sha256 = "sha256-s13m2klObKel2h7yknWSJO2hLMfqsK6aWC8pUxTheAA=";
  };

  deepin-wine-wechat-arch = fetchurl {
    url = "https://github.com/vufa/deepin-wine-wechat-arch/releases/download/v3.5.0.46-1/deepin-wine-wechat-3.5.0.46-1-x86_64.pkg.tar.zst";
    sha256 = "sha256-CAvcplFSOBFMQfWKkGnJjMgBNta5eSAgxmmRrNoJIeA=";
  };

  # autoPatchelfHook 可以自动修改二进制文件
  nativeBuildInputs = [ autoPatchelfHook makeWrapper p7zip coreutils zstd ];

  buildInputs = with pkgsi686Linux;[
    xorg.libXext
    xorg.libX11
    udis86
  ];

  unpackPhase = ''
    ar x ${src}
    tar xf data.tar.xz
    tar xf ${font}
    tar xf ${mmmojo}
    tar xf ${runfile}
    mkdir src
    tar -xf ${deepin-wine-wechat-arch} -C src
  '';

  installPhase = ''
    mkdir temp
    mkdir -p $out/files
    mkdir -p $out/lib
    mkdir -p $out/share
    7z x -aoa "src/opt/apps/*/files/files.7z" -o"temp"
    rm temp/drive_c/windows/Fonts/wqy*
    mv fake_simsun.ttc $out/files
    ln -sf "$out/files/fake_simsun.ttc" "temp/drive_c/windows/Fonts/fake_simsun.ttc"
    7z a -t7z -r "$out/files/files.7z" "./temp/*"
    md5sum "$out/files/files.7z" | awk '{ print $1 }' > "$out/files/files.md5sum"
    mv run.sh $out/files
    mv opt/apps/*/files/dlls/* $out/lib/
    mv opt/apps/*/entries/* $out/share/
    sed -i "
      s|3.9.0.28|${version}|
      s|START_SHELL_PATH=.*|START_SHELL_PATH=\$(whereis run_v4.sh \| cut -b 12-80)|
      s|export DEB_PACKAGE_NAME="com.qq.weixin.deepin"||
      s|deepin-wine6-stable|deepin-wine5|
      s|ARCHIVE_FILE_DIR=.*|ARCHIVE_FILE_DIR=$out/files/files.7z|
      s|WINEPREDLL=\"\$ARCHIVE_FILE_DIR/dlls\"|WINEPREDLL=\"$out/lib\"|
      s|WINEDLLPATH=/opt/\$APPRUN_CMD/lib:/opt/\$APPRUN_CMD/lib64|WINEDLLPATH=/nix/store/s0p49c2hdxfa32vh65w58dzn8s28wvqd-deepin-wine-5.0.16/lib|
      24 i export OUTPATH=$out
      s|/opt/apps/\$DEB_PACKAGE_NAME/files/files.md5sum|$out/files/files.md5sum|
      s|LD_LIBRARY_PATH=/opt/apps/\$DEB_PACKAGE_NAME/files/lib32|LD_LIBRARY_PATH=$out/lib|
      s|/opt/deepinwine/tools/sendkeys.exe|\$(whereis sendkeys.exe \| awk '{ print \$2 }')|
    " "$out/files/run.sh"
    sed -i "
      s|/opt/apps/com.qq.weixin.deepin/files|$out/files|
      s|Wine6|Wine5|
    " "$out/share/applications/com.qq.weixin.deepin.desktop"
  '';
}
