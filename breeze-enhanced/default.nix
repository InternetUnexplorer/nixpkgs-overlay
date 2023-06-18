{ stdenv, lib, fetchFromGitHub, extra-cmake-modules, plasma5Packages
, writeShellScript, nix-update }:

stdenv.mkDerivation rec {
  pname = "breeze-enhanced";
  version = "unstable-2023-03-23";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "BreezeEnhanced";
    rev = "add552ed277d4a9a1565c9e7f2f382300042e0c4";
    hash = "sha256-GpliOf9VBx79xT3zcOISXNuqsY6/T9Q+C7C8+i9sTlM=";
  };

  nativeBuildInputs = [ extra-cmake-modules plasma5Packages.wrapQtAppsHook ];

  buildInputs = with plasma5Packages; [
    frameworkintegration
    kdecoration
    qtx11extras
  ];

  meta = with lib; {
    description = "A fork of KDE Breeze decoration with additional options";
    inherit (src.meta) homepage;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };

  passthru.updateScript = writeShellScript "update-${pname}" ''
    set -e -u -x -o pipefail
    exec ${nix-update}/bin/nix-update --flake ${pname} --version branch
  '';
}
