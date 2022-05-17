{ stdenv, lib, fetchFromGitLab, fetchpatch, extra-cmake-modules, plasma5Packages
}:

stdenv.mkDerivation rec {
  pname = "plasma-applet-thermal-monitor";
  version = "1.3.0";

  src = fetchFromGitLab {
    owner = "agurenko";
    repo = "plasma-applet-thermal-monitor";
    rev = version;
    hash = "sha256-M8Z8wKyxqLHaX+8ZbzjOKkY4a7cH0ZMVhqYkZyuXXTc=";
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
