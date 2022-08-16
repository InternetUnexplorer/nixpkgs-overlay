{ stdenvNoCC, lib, fetchFromGitHub, meson, ninja, sassc }:

stdenvNoCC.mkDerivation rec {
  pname = "adw-gtk3";
  version = "3.6";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "adw-gtk3";
    rev = "v${version}";
    hash = "sha256-8SD3qnjtIAM40JLo7XZAri3QAA4ot8X1XUtdko1Iml4=";
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
