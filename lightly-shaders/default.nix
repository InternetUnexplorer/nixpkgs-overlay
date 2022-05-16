{ stdenv, lib, fetchFromGitHub, cmake, extra-cmake-modules, plasma5Packages
, epoxy }:

stdenv.mkDerivation rec {
  pname = "LightlyShaders";
  version = "20220130";

  src = fetchFromGitHub {
    owner = "a-parhom";
    repo = "LightlyShaders";
    rev = "1a86e5082587348f386a713bb73776c6916825cb";
    hash = "sha256-a6OFp/np+mF3UvR9pEw1O/s0MSDI3Ma4IlbX6gi+Fkc=";
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

  meta = with lib; {
    description = "Round corners and outline effect for kwin";
    inherit (src.meta) homepage;
    platforms = platforms.linux;
  };
}
