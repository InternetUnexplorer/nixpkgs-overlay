{ nextpnrWithGui, callPackage, fetchFromGitHub }:

nextpnrWithGui.overrideAttrs (final: prev: {
  version = "unstable-2023-02-22";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "nextpnr";
    rev = "14050f991bc2e4ce2c6e7f431fe2acd4f0cf2a70";
    hash = "sha256-KE9v8i4xJoU+09rJgjq5c/KrURy/sEtFe3UkqwKEBjo=";
  };

  passthru = (prev.passthru or { }) // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
