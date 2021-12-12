{ stdenv, lib, fetchFromGitHub, extra-cmake-modules, plasma5Packages }:

let
  pname = "classik";
  version = "3.0.breeze5.23.80";
  src = fetchFromGitHub {
    owner = "paulmcauley";
    repo = pname;
    rev = version;
    hash = "sha256-OvekLjHTwfMLwt3RKrC3ls15/B2BpfeIkwZH2z3b+qk=";
  };
in stdenv.mkDerivation {
  inherit pname version src;

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

  meta = with lib; {
    description =
      "A highly customizable binary Window Decoration and Application Style plugin for recent versions of the KDE Plasma desktop";
    inherit (src.meta) homepage;
    license = with licenses; [ bsd3 gpl2Plus mit ];
    platforms = platforms.linux;
  };
}
