{ lib, stdenv, fetchFromGitLab, kdePackages, writeShellScript, nix-update }:

stdenv.mkDerivation rec {
  pname = "thermalmonitor";
  version = "0.2.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "olib";
    repo = "thermalmonitor";
    rev = "v${version}";
    hash = "sha256-K1AjQBZhFDMJH4c4Luj4rLH58kBJbA4lR8utoBxR6wc=";
  };

  buildInputs = with kdePackages; [
    ksystemstats
    libksysguard
    kitemmodels
    kdeclarative
  ];
  nativeBuildInputs = [ kdePackages.extra-cmake-modules ];

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
