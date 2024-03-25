{ lib, stdenv, fetchFromGitLab, plasma5Packages, writeShellScript, nix-update }:

stdenv.mkDerivation rec {
  pname = "thermalmonitor";
  version = "0.1.3";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "olib";
    repo = "thermalmonitor";
    rev = "v${version}";
    hash = "sha256-Gp2PWn8arDblIrgZYuBf08GJ29Nwg4cY33xoJXdD/t8=";
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
