{ stdenv, lib, fetchFromGitHub, cmake, extra-cmake-modules, plasma5Packages }:

let
  pname = "Lightly";
  version = "0.4.1";
in stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "Luwx";
    repo = "Lightly";
    rev = "v${version}";
    hash = "sha256-k1fEZbhzluNlAmj5s/O9X20aCVQxlWQm/Iw/euX7cmI=";
  };

  nativeBuildInputs =
    [ cmake extra-cmake-modules plasma5Packages.wrapQtAppsHook ];

  buildInputs = [
    plasma5Packages.frameworkintegration
    plasma5Packages.kdecoration
    plasma5Packages.qtdeclarative
    plasma5Packages.qtx11extras
  ];

  meta = {
    description = " A modern style for qt applications";
    homepage = "https://github.com/Luwx/Lightly";
    license = lib.licenses.gpl2;
  };
}
