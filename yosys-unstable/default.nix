{ yosys, callPackage, fetchFromGitHub }:

let abc-verifier = callPackage ./abc-verifier.nix { };

in (yosys.override { inherit abc-verifier; }).overrideAttrs (final: prev: {
  version = "unstable-2023-06-13";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "yosys";
    rev = "8b2a0010216f9a15c09bd2f4dc63691949b126df";
    hash = "sha256-YT3qw2hoaKRMoIXkw/5dsR4Al8qVq3UUGBCnoKuJdvI=";
  };

  postPatch = (prev.postPatch or "") + ''
    sed 's/YOSYS_VER := .*/YOSYS_VER := ${final.version}/g' -i Makefile
  '';

  patches = [ ./plugin-search-dirs.patch ];

  passthru = prev.passthru // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
