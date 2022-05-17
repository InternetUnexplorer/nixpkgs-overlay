{ stdenvNoCC, lib, fetchFromGitHub, meson, ninja, sassc }:

stdenvNoCC.mkDerivation rec {
  pname = "adw-gtk3";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "adw-gtk3";
    rev = "v${version}";
    hash = "sha256-I6pQ+UvuEaagy3ysitxa9jR5vNHPC01UMrRe+de1F30=";
  };

  nativeBuildInputs = [ meson ninja ];
  buildInputs = [ sassc ];

  passthru.autoUpdate = "github-releases";

  meta = with lib; {
    description = " The theme from libadwaita ported to GTK 3";
    inherit (src.meta) homepage;
    license = licenses.lgpl21Only;
    platforms = platforms.linux;
  };
}
