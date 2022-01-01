{ stdenv, lib, fetchFromGitHub, extra-cmake-modules, plasma5Packages, libexif
, libheif }:

let
  pname = "plasma5-wallpapers-dynamic";
  version = "3.3.9";
  src = fetchFromGitHub {
    owner = "zzag";
    repo = pname;
    rev = version;
    hash = "sha256-jpNTvV7XX5lOht3PwkPq101XV1ehLAxBladVZZQUsSE=";
  };
in stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [ extra-cmake-modules plasma5Packages.wrapQtAppsHook ];

  buildInputs = with plasma5Packages; [
    plasma-framework
    qtbase
    qtdeclarative
    qtlocation
    libexif
    libheif
  ];

  meta = with lib; {
    description = "Dynamic wallpaper plugin for KDE Plasma";
    inherit (src.meta) homepage;
    license = with licenses; [ bsd3 cc-by-sa-40 cc0 gpl3Plus lgpl3Plus ];
    platforms = platforms.linux;
  };
}
