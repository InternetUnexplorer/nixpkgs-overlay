{ nextpnrWithGui, callPackage, fetchFromGitHub, writeShellScript, nix-update }:

nextpnrWithGui.overrideAttrs (final: prev: {
  version = "nextpnr-0.7-unstable-2024-03-27";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "7f9f75c0d30cc11694aa793b568c0098fb0db1de";
    hash = "sha256-nunVglgTyp2+0Yl4J58GMOH7VlyTFRFFtHTA6rdUyyM=";
  };

  doCheck = false; # Takes too long :(

  passthru.updateScript = writeShellScript "update-nextpnr-unstable" ''
    exec ${nix-update}/bin/nix-update --flake nextpnr-unstable --version branch
  '';
})
