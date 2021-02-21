{ stdenv, fetchFromGitHub, cmake, extra-cmake-modules, plasma5Packages, qt5 }:

stdenv.mkDerivation rec {
  pname = "breeze-enhanced";
  version = "5.19";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "BreezeEnhanced";
    rev = "V${version}";
    hash = "sha256-Y0rN6AFIVSuUG0mwzv8nVK8HdK/fkb9o7JEjyUx8AdI=";
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
