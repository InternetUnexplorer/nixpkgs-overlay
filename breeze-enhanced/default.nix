{ stdenv, lib, fetchFromGitHub, extra-cmake-modules, plasma5Packages }:

stdenv.mkDerivation rec {
  pname = "breeze-enhanced";
  version = "unstable-2022-08-23";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "BreezeEnhanced";
    rev = "e9235c91724913a2cf3153d7e47b963917e51677";
    hash = "sha256-s6SLROPGMMLlUDh4+SyvOxBy3MUVeG1FGefxpFmy8Mw=";
  };

  nativeBuildInputs = [ extra-cmake-modules plasma5Packages.wrapQtAppsHook ];

  buildInputs = with plasma5Packages; [
    frameworkintegration
    kdecoration
    qtx11extras
  ];

  passthru.autoUpdate = "git-commits";

  meta = with lib; {
    description = "A fork of KDE Breeze decoration with additional options";
    inherit (src.meta) homepage;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
