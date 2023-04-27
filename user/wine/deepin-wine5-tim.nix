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
  pname = "deepin-wine-tim";
  version = "3.3.9.22051";

  font = fetchurl {
    url = "https://media.githubusercontent.com/media/zglinus-for-nix/nix-source/master/Applications/wine/fake_simsun.tar.gz";
    sha256 = "sha256-lWAhpcLVl8D6ui0Zn2CmG7L3NP6k+TBwItquzSQ9DS0=";
  };

  deepin-wine-tim-arch = fetchurl {
    url = "https://github.com/vufa/deepin-wine-tim-arch/releases/download/v3.3.9.22051-1/deepin-wine-tim-3.3.9.22051-1-x86_64.pkg.tar.zst";
    sha256 = "sha256-+3Wr9VW6uwMoAeVyfHeaA7VorhbEpoXc2LEr0EkBsU4=";
  };

  # autoPatchelfHook 可以自动修改二进制文件
  nativeBuildInputs = [ autoPatchelfHook makeWrapper p7zip coreutils zstd ];

  buildInputs = with pkgsi686Linux;[

  ];

  unpackPhase = ''
    tar xf ${font}
    tar -xf ${deepin-wine-tim-arch} 
  '';

  installPhase = ''
    mkdir -p $out/files
    mkdir -p $out/share
    mv opt/apps/*/files/* $out/files
    mv usr/share/* $out/share/
    sed -i "
      s|START_SHELL_PATH=.*|START_SHELL_PATH=\$(whereis run_v4.sh \| cut -b 12-80)|
      s|export DEB_PACKAGE_NAME="com.qq.office.deepin"||
      s|ARCHIVE_FILE_DIR=.*|ARCHIVE_FILE_DIR=$out/files/files.7z|
      s|WINEPREDLL=\"\$ARCHIVE_FILE_DIR/dlls\"|WINEPREDLL=\"$out/lib\"|
      s|WINEDLLPATH=/opt/\$APPRUN_CMD/lib:/opt/\$APPRUN_CMD/lib64|WINEDLLPATH=/nix/store/s0p49c2hdxfa32vh65w58dzn8s28wvqd-deepin-wine-5.0.16/lib|
      24 i export OUTPATH=$out
    " "$out/files/run.sh"
    sed -i "
      s|/opt/apps/com.qq.office.deepin/files|$out/files|
      s|wine6|wine5|
    " "$out/share/applications/com.qq.office.deepin.desktop"
  '';
}
