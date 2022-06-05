{ stdenv, lib, fetchFromGitHub, cmake, extra-cmake-modules, plasma5Packages
, epoxy }:

stdenv.mkDerivation rec {
  pname = "LightlyShaders";
  version = "unstable-2022-06-03";

  src = fetchFromGitHub {
    owner = "a-parhom";
    repo = "LightlyShaders";
    rev = "6ceb21da20083c8e2bf9929a47042a9e6df0358a";
    hash = "sha256-hFHdHuxN10kp0m6Gq8zyEp9IWurTvg0tg9u+mXZ79r8=";
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

  passthru.autoUpdate = "git-commits";

  meta = with lib; {
    description = "Round corners and outline effect for kwin";
    inherit (src.meta) homepage;
    platforms = platforms.linux;
  };
}
