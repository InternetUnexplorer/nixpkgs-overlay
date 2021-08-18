{ stdenv, fetchurl, lib, extra-cmake-modules, plasma5Packages, libcap, libnl
, libpcap, lm_sensors }:

let
  pname = "ksysguard";
  version = "5.22.0";
  mirror = "https://download.kde.org/stable";
in stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "${mirror}/${pname}/${version}/${pname}-${version}.tar.xz";
    hash = "sha256-D5xiTl+7Ku6QbY2VY8Wn6wnq84vI5DgsBy+ebYhUYi0=";
  };

  nativeBuildInputs = [
    extra-cmake-modules
    plasma5Packages.kdoctools
    plasma5Packages.wrapQtAppsHook
  ];

  buildInputs = [
    plasma5Packages.kconfig
    plasma5Packages.kcoreaddons
    plasma5Packages.ki18n
    plasma5Packages.kiconthemes
    plasma5Packages.kinit
    plasma5Packages.kitemviews
    plasma5Packages.knewstuff
    plasma5Packages.libksysguard
    plasma5Packages.networkmanager-qt
    plasma5Packages.qtbase
    libcap
    libnl
    libpcap
    lm_sensors
  ];

  meta = with lib; {
    description = "Resource usage monitor for your computer";
    homepage = "https://apps.kde.org/ksysguard";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
