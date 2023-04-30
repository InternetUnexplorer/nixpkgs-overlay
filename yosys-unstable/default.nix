{ yosys, callPackage, fetchFromGitHub }:

let abc-verifier = callPackage ./abc-verifier.nix { };

in (yosys.override { inherit abc-verifier; }).overrideAttrs (final: prev: {
  version = "unstable-2023-04-24";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "yosys";
    rev = "cee3cb31b98e3b67af3165969c8cfc0616c37e19";
    hash = "sha256-Er9IPbr5RAZQRD+ukq0Rj7ZGLEYhpee3MMbC8vPPvNs=";
  };

  postPatch = (prev.postPatch or "") + ''
    sed 's/YOSYS_VER := .*/YOSYS_VER := ${final.version}/g' -i Makefile
  '';

  passthru = prev.passthru // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
