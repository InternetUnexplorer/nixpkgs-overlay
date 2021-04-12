{ stdenv, lib, fetchFromGitHub, cmake, extra-cmake-modules, plasma5Packages
, libexif, libheif }:

let
  pname = "plasma5-wallpapers-dynamic";
  version = "3.3.9";
in stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "zzag";
    repo = "plasma5-wallpapers-dynamic";
    rev = version;
    hash = "sha256-jpNTvV7XX5lOht3PwkPq101XV1ehLAxBladVZZQUsSE=";
  };

  nativeBuildInputs =
    [ cmake extra-cmake-modules plasma5Packages.wrapQtAppsHook ];

  buildInputs = [
    plasma5Packages.qtbase
    plasma5Packages.qtdeclarative
    plasma5Packages.qtlocation
    plasma5Packages.plasma-framework
    libexif
    libheif
  ];

  meta = {
    description = "Dynamic wallpaper plugin for KDE Plasma";
    homepage = "https://github.com/zzag/plasma5-wallpapers-dynamic";
    license = with lib.licenses; [ bsd3 cc-by-sa-40 cc0 gpl3Plus lgpl3Plus ];
  };
}
