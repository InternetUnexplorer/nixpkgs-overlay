{ yosys, callPackage, fetchFromGitHub }:

let abc-verifier = callPackage ./abc-verifier.nix { };

in (yosys.override { inherit abc-verifier; }).overrideAttrs (final: prev: {
  version = "unstable-2023-04-07";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "yosys";
    rev = "101075611fc5698739180017bf96b1abf140c8e7";
    hash = "sha256-lbueeyWEIH7o6+SAJYFVKq/RBG5V/ZspBR5x6hU2/kY=";
  };

  postPatch = (prev.postPatch or "") + ''
    sed 's/YOSYS_VER := .*/YOSYS_VER := ${final.version}/g' -i Makefile
  '';

  passthru = prev.passthru // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
