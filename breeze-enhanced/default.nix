{ stdenv, lib, fetchFromGitHub, extra-cmake-modules, plasma5Packages
, writeShellScript, nix-update }:

stdenv.mkDerivation rec {
  pname = "breeze-enhanced";
  version = "unstable-2024-03-17";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "BreezeEnhanced";
    rev = "b3de58529be2a671414b44f318993dbd34fd1eda";
    hash = "sha256-YoDIVRlzEm5pTNW9DVUqBTaSgHjHhx390HSZLF1kuCE=";
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
    exec ${nix-update}/bin/nix-update --flake ${pname} --version branch
  '';
}
