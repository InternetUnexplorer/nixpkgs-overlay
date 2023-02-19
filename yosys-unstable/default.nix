{ yosys, callPackage, fetchFromGitHub }:

let abc-verifier = callPackage ./abc-verifier.nix { };

in (yosys.override { inherit abc-verifier; }).overrideAttrs (final: prev: {
  version = "unstable-2023-02-18";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "yosys";
    rev = "f0116330bce4e787dcbbf81c6e901a44715589a8";
    hash = "sha256-aUNfa93H7E5s6YL5LpZ/aJYY6HYs+nJ6CJHIxvsIaHA=";
  };

  postPatch = (prev.postPatch or "") + ''
    sed 's/YOSYS_VER := .*/YOSYS_VER := ${final.version}/g' -i Makefile
  '';

  passthru = prev.passthru // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
