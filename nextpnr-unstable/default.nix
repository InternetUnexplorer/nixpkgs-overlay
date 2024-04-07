{ nextpnrWithGui, callPackage, fetchFromGitHub, writeShellScript, nix-update }:

nextpnrWithGui.overrideAttrs (final: prev: {
  version = "nextpnr-0.7-unstable-2024-04-05";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "9bb46b98b474cacf3f21268e8962a7ecd6a2ec6d";
    hash = "sha256-Vvv8jAPwSzR/7JPL8lEqVdTjTiXoMnvFXwxB1S5omoc=";
  };

  doCheck = false; # Takes too long :(

  passthru.updateScript = writeShellScript "update-nextpnr-unstable" ''
    exec ${nix-update}/bin/nix-update --flake nextpnr-unstable --version branch
  '';
})
