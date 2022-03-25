{ stdenvNoCC, lib, fetchFromGitHub, meson, ninja, sassc }:

stdenvNoCC.mkDerivation rec {
  pname = "adw-gtk3";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = "adw-gtk3";
    rev = "v${version}";
    hash = "sha256-HiNaf8Z0MdkRMNglrhTrKuF5RzkNP6tp2DWhCTZ/sQg=";
  };

  nativeBuildInputs = [ meson ninja ];
  buildInputs = [ sassc ];

  meta = with lib; {
    description = " The theme from libadwaita ported to GTK 3";
    inherit (src.meta) homepage;
    license = licenses.lgpl21Only;
    platforms = platforms.linux;
  };
}
