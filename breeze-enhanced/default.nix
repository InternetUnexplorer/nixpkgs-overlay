{ stdenv, lib, fetchFromGitHub, extra-cmake-modules, plasma5Packages
, writeShellScript, nix-update }:

stdenv.mkDerivation rec {
  pname = "breeze-enhanced";
  version = "V6.0-unstable-2024-09-09";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "BreezeEnhanced";
    rev = "aef497ee1cf54cfc9d493171eae276821f856616";
    hash = "sha256-p1bDqQrWGxG5o87dBBbbYPRP0o0xPd3oYwujEp2fMLs=";
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
    broken = true;
  };

  passthru.updateScript = writeShellScript "update-${pname}" ''
    exec ${nix-update}/bin/nix-update --flake ${pname} --version branch
  '';
}
