{ yosys, callPackage, fetchFromGitHub }:

let abc-verifier = callPackage ./abc-verifier.nix { };

in (yosys.override { inherit abc-verifier; }).overrideAttrs (final: prev: {
  version = "unstable-2023-05-15";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "yosys";
    rev = "acfdc5cc4246ab6e146f25a9c7f6895dd1fa47e5";
    hash = "sha256-r/lFXU+zTW+vI3QiqYJPhz352s0QxwrXIX0rA8WN77I=";
  };

  postPatch = (prev.postPatch or "") + ''
    sed 's/YOSYS_VER := .*/YOSYS_VER := ${final.version}/g' -i Makefile
  '';

  passthru = prev.passthru // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
