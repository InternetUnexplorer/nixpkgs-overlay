{ nextpnrWithGui, callPackage, fetchFromGitHub, writeShellScript, nix-update }:

nextpnrWithGui.overrideAttrs (final: prev: {
  version = "unstable-2023-09-02";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "79c6840fefcf84d001b0c1b269cd0198ee9d3dba";
    hash = "sha256-koNWR7PFifaLkIjbhHy5nZxxHjsXW3z+PlM5RolBn7A=";
  };

  passthru.updateScript = writeShellScript "update-nextpnr-unstable" ''
    exec ${nix-update}/bin/nix-update --flake nextpnr-unstable --version branch
  '';
})
