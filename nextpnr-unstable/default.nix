{ nextpnrWithGui, callPackage, fetchFromGitHub, writeShellScript, nix-update }:

nextpnrWithGui.overrideAttrs (final: prev: {
  version = "nextpnr-0.7-unstable-2024-03-22";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "b4da57598eaac912bbf3fa30462da7b511c940ea";
    hash = "sha256-TEjDsFVRVMuYS+OBmX40txyup0Uk93B7nP/zD5Qo87E=";
  };

  doCheck = false; # Takes too long :(

  passthru.updateScript = writeShellScript "update-nextpnr-unstable" ''
    exec ${nix-update}/bin/nix-update --flake nextpnr-unstable --version branch
  '';
})
