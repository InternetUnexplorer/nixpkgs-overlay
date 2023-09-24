{ lib, stdenv, fetchFromGitLab, plasma5Packages, writeShellScript, nix-update }:

stdenv.mkDerivation rec {
  pname = "thermalmonitor";
  version = "0.1.2-kf5";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "olib";
    repo = "thermalmonitor";
    rev = "v${version}";
    hash = "sha256-biE9oygebz1bSmCdq39qJdeXUDMjdyEqQRCXCPVtOsI=";
  };

  buildInputs = with plasma5Packages; [
    ksystemstats
    libksysguard
    kitemmodels
    kdeclarative
  ];
  nativeBuildInputs = [ plasma5Packages.extra-cmake-modules ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "A KDE Plasmoid for displaying system temperatures";
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.linux;
  };

  passthru.updateScript = writeShellScript "update-${pname}" ''
    exec ${nix-update}/bin/nix-update --flake ${pname}
  '';
}
