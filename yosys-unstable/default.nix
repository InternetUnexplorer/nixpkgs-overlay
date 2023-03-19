{ yosys, callPackage, fetchFromGitHub }:

let abc-verifier = callPackage ./abc-verifier.nix { };

in (yosys.override { inherit abc-verifier; }).overrideAttrs (final: prev: {
  version = "unstable-2023-03-16";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "yosys";
    rev = "ceef00c35e6417ba480ae40c3fe919b50e18e1be";
    hash = "sha256-AJy8yErpTsnmRAWxnEaajtS87LelQkG67g9O0abDcPo=";
  };

  postPatch = (prev.postPatch or "") + ''
    sed 's/YOSYS_VER := .*/YOSYS_VER := ${final.version}/g' -i Makefile
  '';

  passthru = prev.passthru // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
