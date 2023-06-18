{ nextpnrWithGui, callPackage, fetchFromGitHub, writeShellScript, nix-update }:

nextpnrWithGui.overrideAttrs (final: prev: {
  version = "unstable-2023-06-16";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "6c0b4443d5fbcdc0d33db3b38e031a65174c6019";
    hash = "sha256-VIT2WtMeyIFSGwweYNAw1J9OIxumCwO/C9raMpRwztc=";
  };

  passthru.updateScript = writeShellScript "update-nextpnr-unstable" ''
    set -e -u -x -o pipefail
    exec ${nix-update}/bin/nix-update --flake nextpnr-unstable --version branch
  '';
})
