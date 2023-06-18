{ stdenv, lib, fetchFromGitLab, fetchpatch, extra-cmake-modules, plasma5Packages
, writeShellScript, nix-update }:

stdenv.mkDerivation rec {
  pname = "plasma-applet-thermal-monitor";
  version = "unstable-2023-05-06";

  src = fetchFromGitLab {
    owner = "agurenko";
    repo = "plasma-applet-thermal-monitor";
    rev = "146f3148ccf1b95556278fd3c6f024842cb45c9d";
    hash = "sha256-EzbNKu+RBq5ZHbUveBEkwt2mMPMd3soaqJPXjD/1MnQ=";
  };

  nativeBuildInputs = [ extra-cmake-modules plasma5Packages.wrapQtAppsHook ];

  buildInputs = [ plasma5Packages.plasma-workspace ];

  meta = with lib; {
    description =
      "Plasma 5 applet for monitoring CPU, GPU and other available temperature sensors";
    inherit (src.meta) homepage;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };

  passthru.updateScript = writeShellScript "update-${pname}" ''
    set -e -u -x -o pipefail
    exec ${nix-update}/bin/nix-update --flake ${pname} --version branch
  '';
}
