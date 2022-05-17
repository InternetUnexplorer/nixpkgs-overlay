{ stdenv, lib, fetchFromGitHub, extra-cmake-modules, plasma5Packages }:

stdenv.mkDerivation rec {
  pname = "classik";
  version = "3.0.breeze5.23.80";

  src = fetchFromGitHub {
    owner = "paulmcauley";
    repo = "classik";
    rev = version;
    hash = "sha256-OvekLjHTwfMLwt3RKrC3ls15/B2BpfeIkwZH2z3b+qk=";
  };

  outputs = [ "bin" "dev" "out" ];

  nativeBuildInputs = [ extra-cmake-modules plasma5Packages.wrapQtAppsHook ];

  buildInputs = with plasma5Packages; [
    frameworkintegration
    kcmutils
    kconfigwidgets
    kcoreaddons
    kdecoration
    kguiaddons
    ki18n
    kwayland
    kwindowsystem
    plasma-framework
    qtdeclarative
    qtx11extras
  ];

  passthru.autoUpdate = "github-releases";

  meta = with lib; {
    description =
      "A highly customizable binary Window Decoration and Application Style plugin for recent versions of the KDE Plasma desktop";
    inherit (src.meta) homepage;
    license = with licenses; [ bsd3 gpl2Plus mit ];
    platforms = platforms.linux;
  };
}
