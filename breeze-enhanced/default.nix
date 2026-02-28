{ stdenv, lib, fetchFromGitHub, extra-cmake-modules, plasma5Packages
, writeShellScript, nix-update }:

stdenv.mkDerivation rec {
  pname = "breeze-enhanced";
  version = "V6.4-unstable-2025-11-07";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "BreezeEnhanced";
    rev = "bf9ea179b06c8e398f69f47d83cae81110ef0cc8";
    hash = "sha256-yfN2SKJcGhPe4/7nvbRgLyux+b9rIQlm4lJINpV20Ys=";
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
