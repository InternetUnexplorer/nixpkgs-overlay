{ nextpnrWithGui, callPackage, fetchFromGitHub, writeShellScript, nix-update }:

nextpnrWithGui.overrideAttrs (final: prev: {
  version = "unstable-2024-01-29";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "b05cb86291c837e739962080378d68da123f0009";
    hash = "sha256-BSl70D0ewN9u+nLT965eNNaLyyHIJsvrOhhd+b2kQ2k=";
  };

  doCheck = false; # Takes too long :(

  passthru.updateScript = writeShellScript "update-nextpnr-unstable" ''
    exec ${nix-update}/bin/nix-update --flake nextpnr-unstable --version branch
  '';
})
