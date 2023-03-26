{ yosys, callPackage, fetchFromGitHub }:

let abc-verifier = callPackage ./abc-verifier.nix { };

in (yosys.override { inherit abc-verifier; }).overrideAttrs (final: prev: {
  version = "unstable-2023-03-24";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "yosys";
    rev = "53c0a6b780199dc56348916acf7c00e30f65e1ec";
    hash = "sha256-shTv4ZItOQSDArta7on2USmMkCuya2ZYKZ9lUhRL47s=";
  };

  postPatch = (prev.postPatch or "") + ''
    sed 's/YOSYS_VER := .*/YOSYS_VER := ${final.version}/g' -i Makefile
  '';

  passthru = prev.passthru // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
