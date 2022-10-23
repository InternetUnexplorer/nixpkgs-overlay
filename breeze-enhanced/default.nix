{ stdenv, lib, fetchFromGitHub, extra-cmake-modules, plasma5Packages }:

stdenv.mkDerivation rec {
  pname = "breeze-enhanced";
  version = "unstable-2022-10-18";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "BreezeEnhanced";
    rev = "68e1e761d63c598142544c63be8c42f4af073c38";
    hash = "sha256-j0u5wzHHViAyAaNVHwhcEToO6bThK4oKpG0f8NQNxk4=";
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
