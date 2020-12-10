{ stdenv, cmake, extra-cmake-modules, plasma5, kdeFrameworks, qt5 }:

stdenv.mkDerivation rec {
  pname = "breeze-enhanced";
  version = "5.18";

  src = builtins.fetchTarball {
    url = "https://github.com/tsujan/BreezeEnhanced/archive/V${version}.tar.gz";
    sha256 = "1yrdnb9yq5n41j2g144qgv3bbbp3vfpq9c8bzdyh17v56ipbz9zq";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules ];
  buildInputs =
    [ plasma5.kdecoration kdeFrameworks.frameworkintegration qt5.qtx11extras ];
}
