{ yosys, callPackage, fetchFromGitHub }:

let abc-verifier = callPackage ./abc-verifier.nix { };

in (yosys.override { inherit abc-verifier; }).overrideAttrs (final: prev: {
  version = "unstable-2023-02-17";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "yosys";
    rev = "1cfedc90ce7b2bd63d75883a4e8c36fd44f0e4e7";
    hash = "sha256-t9X7Vj+TnK3gKyNE1MD65dNzIRMdD65Hmq6YWA68GWo=";
  };

  postPatch = (prev.postPatch or "") + ''
    sed 's/YOSYS_VER := .*/YOSYS_VER := ${final.version}/g' -i Makefile
  '';

  passthru = prev.passthru // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
