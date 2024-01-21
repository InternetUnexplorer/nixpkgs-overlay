{ nextpnrWithGui, callPackage, fetchFromGitHub, writeShellScript, nix-update }:

nextpnrWithGui.overrideAttrs (final: prev: {
  version = "unstable-2024-01-18";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "4220ce100776381fcaed4ceb2efed722e7ddf474";
    hash = "sha256-ZlhLe+QRWb6wCPW8PTQSKt2HLY3Jbl+/dL/lWhBxqYI=";
  };

  doCheck = false; # Takes too long :(

  passthru.updateScript = writeShellScript "update-nextpnr-unstable" ''
    exec ${nix-update}/bin/nix-update --flake nextpnr-unstable --version branch
  '';
})
