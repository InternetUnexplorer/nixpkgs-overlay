{ nextpnrWithGui, callPackage, fetchFromGitHub, writeShellScript, nix-update }:

nextpnrWithGui.overrideAttrs (final: prev: {
  version = "unstable-2023-06-14";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "787fac764921c587e94d55d58d30049eeb86ab2a";
    hash = "sha256-Zjbb61G6gF9OEBcyUf3f3Dcxf8DDfdygPqWzk7Y9Goo=";
  };

  passthru.updateScript = writeShellScript "update-${prev.pname}" ''
    set -e -u -x -o pipefail
    exec ${nix-update}/bin/nix-update --flake ${prev.pname} --version branch
  '';
})
