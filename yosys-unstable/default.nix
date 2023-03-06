{ yosys, callPackage, fetchFromGitHub }:

let abc-verifier = callPackage ./abc-verifier.nix { };

in (yosys.override { inherit abc-verifier; }).overrideAttrs (final: prev: {
  version = "unstable-2023-03-02";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "yosys";
    rev = "9747e55d9520631c4405ec42c02d5197c2ea57ab";
    hash = "sha256-W7VhmWJjPYLJVB1B81yBXdaVAIux/D6zBRGwfy1bIRU=";
  };

  postPatch = (prev.postPatch or "") + ''
    sed 's/YOSYS_VER := .*/YOSYS_VER := ${final.version}/g' -i Makefile
  '';

  passthru = prev.passthru // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
