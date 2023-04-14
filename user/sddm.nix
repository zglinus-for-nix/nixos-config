{ stdenv 
, fetchurl
}:

stdenv.mkDerivation rec {
  src = fetchurl {
    url = "https://media.githubusercontent.com/media/zglinus-for-nix/nix-source/master/Applications/sugar-candy-magic.tar.gz";
    sha256 = "sha256-xVwlMygty1iDdT5FJ6Fr7pPeiDzUwOFAheOYEBPdJFM=";
  };
  pname = "sugar-candy";
  version = "1.2";
  dontBuild = true;

  unpackPhase = ''
    tar xzf ${src}
  '';

  installPhase = ''
    mkdir -p $out/share/sddm/themes/sugar-candy
    cp -aR sugar-candy-magic/* $out/share/sddm/themes/sugar-candy
  '';

}

