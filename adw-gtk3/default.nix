{ stdenvNoCC, lib, fetchFromGitHub, meson, ninja, sassc }:

stdenvNoCC.mkDerivation rec {
  pname = "adw-gtk3";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "adw-gtk3";
    rev = "v${version}";
    hash = "sha256-J4hNNI6IKdMMMb+Qgv39d6WsVv/xi4swr5/ipUsyPPY=";
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
