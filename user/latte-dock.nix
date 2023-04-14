{ stdenv
, lib
, cmake
, xorg
, libsForQt5
, fetchFromGitLab
, extra-cmake-modules
, wayland
, wrapQtAppsHook
} :

stdenv.mkDerivation rec {
  pname = "latte-dock";
  version = "20230409";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "plasma";
    repo = "latte-dock";
    rev = "6a78c351d99438f97236ccd3ee63cf3de5bc9c14";
    sha256 = "sha256-wq89QD47wkbHSdFtnFWjWYGUZmQDnyMFW/NOxe8u8dg=";
  };

  buildInputs = [ libsForQt5.plasma-framework libsForQt5.plasma-workspace libsForQt5.plasma-wayland-protocols libsForQt5.qtwayland xorg.libpthreadstubs xorg.libXdmcp xorg.libSM wayland ];

  nativeBuildInputs = [ extra-cmake-modules cmake libsForQt5.karchive libsForQt5.kwindowsystem
    libsForQt5.qtx11extras libsForQt5.qtx11extras libsForQt5.kcrash libsForQt5.knewstuff
    wrapQtAppsHook];

  
  patches = [
    ./0001-Disable-autostart-latte.patch
  ];


  postInstall = ''
    mkdir -p $out/etc/xdg/autostart
    cp $out/share/applications/org.kde.latte-dock.desktop $out/etc/xdg/autostart
  '';


}