{ stdenv, lib, fetchFromGitHub, cmake, extra-cmake-modules, plasma5Packages }:

stdenv.mkDerivation rec {
  pname = "Lightly";
  version = "unstable-2022-05-02";

  src = fetchFromGitHub {
    owner = "Luwx";
    repo = "Lightly";
    rev = "121a61e5b67e5122449c80301e41b4de3649b0d5";
    hash = "sha256-UmttzKFkuZupFpBrTQYIsLCpNRLcd5CkabQN5n5zkJQ=";
  };

  nativeBuildInputs =
    [ cmake extra-cmake-modules plasma5Packages.wrapQtAppsHook ];

  buildInputs = [
    plasma5Packages.frameworkintegration
    plasma5Packages.kdecoration
    plasma5Packages.qtdeclarative
    plasma5Packages.qtx11extras
  ];

  passthru.autoUpdate = "git-commits";

  meta = with lib; {
    description = " A modern style for Qt applications";
    inherit (src.meta) homepage;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
