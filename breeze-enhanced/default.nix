{ stdenv, lib, fetchFromGitHub, extra-cmake-modules, plasma5Packages }:

stdenv.mkDerivation rec {
  pname = "breeze-enhanced";
  version = "unstable-2023-03-14";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "BreezeEnhanced";
    rev = "a1cd1d6bfea3f59ecbcb004147917a2b01b409cb";
    hash = "sha256-V5lNRJuJUPzQvjGGJQH8Q/xqGbHmFApfbkYOsc8z4nI=";
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
