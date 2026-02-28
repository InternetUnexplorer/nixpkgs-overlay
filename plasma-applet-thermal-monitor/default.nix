{ stdenv, lib, fetchFromGitLab, fetchpatch, extra-cmake-modules, kdePackages
, writeShellScript, nix-update }:

stdenv.mkDerivation rec {
  pname = "plasma-applet-thermal-monitor";
  version = "1.3.0-unstable-2024-07-16";

  src = fetchFromGitLab {
    owner = "agurenko";
    repo = "plasma-applet-thermal-monitor";
    rev = "acc910510368867ee2a95205623840565a231ca3";
    hash = "sha256-rR8FgtLMwShaiuYpgy9M1RH4IJcFtYwmfEgiEWDdpRE=";
  };

  nativeBuildInputs = [ extra-cmake-modules kdePackages.wrapQtAppsHook ];
  buildInputs = [ kdePackages.plasma-workspace ];

  meta = with lib; {
    description =
      "Plasma applet for monitoring CPU, GPU and other available temperature sensors";
    inherit (src.meta) homepage;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };

  passthru.updateScript = writeShellScript "update-${pname}" ''
    exec ${nix-update}/bin/nix-update --flake ${pname} --version branch
  '';
}
