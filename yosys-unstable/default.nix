{ yosys, callPackage, fetchFromGitHub }:

let abc-verifier = callPackage ./abc-verifier.nix { };

in (yosys.override { inherit abc-verifier; }).overrideAttrs (final: prev: {
  version = "unstable-2023-05-10";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "yosys";
    rev = "d82bae32bee63d4a521e5cb081359aa5a35213f1";
    hash = "sha256-K3ky1C+IZR3dsXTwGstzLmcKd4gVZnfjbzFpGQMmhrQ=";
  };

  postPatch = (prev.postPatch or "") + ''
    sed 's/YOSYS_VER := .*/YOSYS_VER := ${final.version}/g' -i Makefile
  '';

  passthru = prev.passthru // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
