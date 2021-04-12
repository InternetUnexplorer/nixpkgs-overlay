{ stdenv, fetchFromGitHub, cmake, extra-cmake-modules, plasma5Packages, qt5 }:

stdenv.mkDerivation rec {
  pname = "breeze-enhanced";
  version = "5.20";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "BreezeEnhanced";
    rev = "V${version}";
    hash = "sha256-a64/hSFJnmr1sF+5ThLpjtQFFbglKFQ6sm75KxSbChA=";
  };

  nativeBuildInputs =
    [ cmake extra-cmake-modules plasma5Packages.wrapQtAppsHook ];
  buildInputs = [
    plasma5Packages.kdecoration
    plasma5Packages.frameworkintegration
    qt5.qtx11extras
  ];

  meta = {
    description = "A fork of KDE Breeze decoration with additional options";
    homepage = "https://github.com/tsujan/BreezeEnhanced";
    license = "GPLv3";
  };
}
