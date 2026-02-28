{ lib, stdenv, fetchFromGitLab, kdePackages, cmake, writeShellScript, nix-update
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "thermalmonitor";
  version = "0.2.7";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "olib";
    repo = "thermalmonitor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1TaeE9nsivkaiaCA8lTqwS3DGxh4MlsX1D5Y3VaU584=";
  };

  nativeBuildInputs = [ cmake kdePackages.extra-cmake-modules ];
  buildInputs = [ kdePackages.libplasma ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "KDE Plasmoid for showing system temperatures";
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.linux;
  };

  passthru.updateScript = writeShellScript "update-${finalAttrs.pname}" ''
    exec ${nix-update}/bin/nix-update --flake ${finalAttrs.pname}
  '';
})
