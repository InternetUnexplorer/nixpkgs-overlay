{ stdenv, fetchFromGitHub, cmake, extra-cmake-modules, plasma5Packages, qt5 }:

stdenv.mkDerivation rec {
  pname = "breeze-enhanced";
  version = "5.18";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "BreezeEnhanced";
    rev = "V${version}";
    sha256 = "1yrdnb9yq5n41j2g144qgv3bbbp3vfpq9c8bzdyh17v56ipbz9zq";
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
