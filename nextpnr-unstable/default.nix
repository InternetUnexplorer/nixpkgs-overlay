{ nextpnrWithGui, callPackage, fetchFromGitHub, writeShellScript, nix-update }:

nextpnrWithGui.overrideAttrs (final: prev: {
  version = "nextpnr-0.7-unstable-2024-06-18";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "a29a17f8f24158b31a9272d55f48cd46d7db50fa";
    hash = "sha256-PZUA5utRpuOlAwtEs/hf2K32u5vVV37v1YTeyNEo+9s=";
  };

  doCheck = false; # Takes too long :(

  passthru.updateScript = writeShellScript "update-nextpnr-unstable" ''
    exec ${nix-update}/bin/nix-update --flake nextpnr-unstable --version branch
  '';
})
