{ stdenv, lib, fetchFromGitHub, cmake, extra-cmake-modules, plasma5Packages }:

stdenv.mkDerivation rec {
  pname = "Lightly";
  version = "20211117";

  src = fetchFromGitHub {
    owner = "Luwx";
    repo = "Lightly";
    rev = "4a918fee87ed37b165c209c4857e8ed473f00acb";
    hash = "sha256-K0Zw4BOwT1esDMl4p8y6HjPUCdr8JHNKFdVQVk63nwo=";
  };

  nativeBuildInputs =
    [ cmake extra-cmake-modules plasma5Packages.wrapQtAppsHook ];

  buildInputs = [
    plasma5Packages.frameworkintegration
    plasma5Packages.kdecoration
    plasma5Packages.qtdeclarative
    plasma5Packages.qtx11extras
  ];

  meta = with lib; {
    description = " A modern style for Qt applications";
    inherit (src.meta) homepage;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
