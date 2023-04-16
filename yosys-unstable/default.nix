{ yosys, callPackage, fetchFromGitHub }:

let abc-verifier = callPackage ./abc-verifier.nix { };

in (yosys.override { inherit abc-verifier; }).overrideAttrs (final: prev: {
  version = "unstable-2023-04-15";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "yosys";
    rev = "a9c792dceef4be21059ff4732d1aff62e67d96bc";
    hash = "sha256-djxHITY3xgAbZX1mR9I/5CofcGsdBwKiwmhQXJXNcyE=";
  };

  postPatch = (prev.postPatch or "") + ''
    sed 's/YOSYS_VER := .*/YOSYS_VER := ${final.version}/g' -i Makefile
  '';

  passthru = prev.passthru // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
