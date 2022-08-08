{ stdenvNoCC, lib, fetchFromGitHub, meson, ninja, sassc }:

stdenvNoCC.mkDerivation rec {
  pname = "adw-gtk3";
  version = "3.5";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "adw-gtk3";
    rev = "v${version}";
    hash = "sha256-6aEYveKkpwtyDyFjsmvT91NtnawolVVMAYd+07Z4uI0=";
  };

  nativeBuildInputs = [ meson ninja sassc ];

  passthru.autoUpdate = "github-releases";

  meta = with lib; {
    description = "The theme from libadwaita ported to GTK 3";
    inherit (src.meta) homepage;
    license = licenses.lgpl21Only;
    platforms = platforms.linux;
  };
}
