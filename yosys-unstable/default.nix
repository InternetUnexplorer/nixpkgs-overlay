{ yosys, callPackage, fetchFromGitHub }:

let abc-verifier = callPackage ./abc-verifier.nix { };

in (yosys.override { inherit abc-verifier; }).overrideAttrs (final: prev: {
  version = "unstable-2023-05-05";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "yosys";
    rev = "4251d37f4fc66108ead53af677739563de4ee7f8";
    hash = "sha256-6sPkDX12+4wdeip/PhYvN78ukzzUzOb9Lh4cjxVpwxg=";
  };

  postPatch = (prev.postPatch or "") + ''
    sed 's/YOSYS_VER := .*/YOSYS_VER := ${final.version}/g' -i Makefile
  '';

  passthru = prev.passthru // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
