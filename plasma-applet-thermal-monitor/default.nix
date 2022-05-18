{ stdenv, lib, fetchFromGitLab, fetchpatch, extra-cmake-modules, plasma5Packages
}:

stdenv.mkDerivation rec {
  pname = "plasma-applet-thermal-monitor";
  version = "a0f577ee6cfb3c4db41951303144adeef3b11250";

  src = fetchFromGitLab {
    owner = "agurenko";
    repo = "plasma-applet-thermal-monitor";
    rev = version;
    hash = "sha256-pJ6zeT9GJ42qQ2+3lykfsFdcveQsvKwr48ZcivaOgtk=";
  };

  nativeBuildInputs = [ extra-cmake-modules plasma5Packages.wrapQtAppsHook ];

  buildInputs = [ plasma5Packages.plasma-workspace ];

  passthru.autoUpdate = "git-commits";

  meta = with lib; {
    description =
      "Plasma 5 applet for monitoring CPU, GPU and other available temperature sensors";
    inherit (src.meta) homepage;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
