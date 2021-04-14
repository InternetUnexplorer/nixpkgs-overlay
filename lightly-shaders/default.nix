{ stdenv, lib, fetchFromGitHub, cmake, extra-cmake-modules, plasma5Packages
, epoxy }:

let
  pname = "LightlyShaders";
  version = "3c2572b";
in stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "Luwx";
    repo = "LightlyShaders";
    rev = version;
    hash = "sha256-6QjjU2826UpeOPgjGtcg/XXF0hQze/6yY//okijrqHU=";
  };

  nativeBuildInputs =
    [ cmake extra-cmake-modules plasma5Packages.wrapQtAppsHook ];

  buildInputs = [
    epoxy.dev
    plasma5Packages.kconfigwidgets
    plasma5Packages.kcrash
    plasma5Packages.kglobalaccel
    plasma5Packages.kguiaddons
    plasma5Packages.ki18n
    plasma5Packages.kinit
    plasma5Packages.kio
    plasma5Packages.knotifications
    plasma5Packages.kwin.dev
    plasma5Packages.qtbase
    plasma5Packages.qttools
    plasma5Packages.qtx11extras
  ];

  patches = [ ./0000-fix-install-paths.patch ];

  cmakeFlags = [
    "-DMODULEPATH=${plasma5Packages.qtbase.qtPluginPrefix}"
    "-DDATAPATH=share"
  ];

  meta = {
    description = "Round corners and outline effect for kwin";
    homepage = "https://github.com/Luwx/LightlyShaders";
  };
}
