{ nextpnrWithGui, callPackage, fetchFromGitHub, writeShellScript, nix-update }:

nextpnrWithGui.overrideAttrs (final: prev: {
  version = "nextpnr-0.7-unstable-2024-05-08";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "423f1b7159e39bf6995c773042868422d8531e48";
    hash = "sha256-szuY1mDNBSFcXI0fuyCwob5GAZqqqNyAev+hei8xyJs=";
  };

  doCheck = false; # Takes too long :(

  passthru.updateScript = writeShellScript "update-nextpnr-unstable" ''
    exec ${nix-update}/bin/nix-update --flake nextpnr-unstable --version branch
  '';
})
