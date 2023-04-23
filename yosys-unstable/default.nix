{ yosys, callPackage, fetchFromGitHub }:

let abc-verifier = callPackage ./abc-verifier.nix { };

in (yosys.override { inherit abc-verifier; }).overrideAttrs (final: prev: {
  version = "unstable-2023-04-23";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "yosys";
    rev = "51dd0290241c521f5498f71f4fd4fb0598d83a76";
    hash = "sha256-BE+DoXge/c6ROwEzbiVz7pDMunZ8yJ5CEY4QrZBcNyI=";
  };

  postPatch = (prev.postPatch or "") + ''
    sed 's/YOSYS_VER := .*/YOSYS_VER := ${final.version}/g' -i Makefile
  '';

  passthru = prev.passthru // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
