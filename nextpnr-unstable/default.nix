{ nextpnrWithGui, callPackage, fetchFromGitHub, writeShellScript, nix-update }:

nextpnrWithGui.overrideAttrs (final: prev: {
  version = "unstable-2023-11-17";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "55635cf2cda7af3a301da33293cc0094e7d540a6";
    hash = "sha256-I8ejx2bDb7rJ+HbfN4ZuvVzQhLsx0T/xuSTCmaD9tBY=";
  };

  passthru.updateScript = writeShellScript "update-nextpnr-unstable" ''
    exec ${nix-update}/bin/nix-update --flake nextpnr-unstable --version branch
  '';
})
