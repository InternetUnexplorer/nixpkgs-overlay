{ nextpnrWithGui, callPackage, fetchFromGitHub, writeShellScript, nix-update }:

nextpnrWithGui.overrideAttrs (final: prev: {
  version = "unstable-2023-10-29";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "d6f54fd9df879643f795b3d96c25e6a84cf48a77";
    hash = "sha256-AxikVAn7WaCQDkSmNDISN7vOFHguTWA9Or8Unn/hhfI=";
  };

  passthru.updateScript = writeShellScript "update-nextpnr-unstable" ''
    exec ${nix-update}/bin/nix-update --flake nextpnr-unstable --version branch
  '';
})
