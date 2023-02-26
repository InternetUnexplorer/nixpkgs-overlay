{ yosys, callPackage, fetchFromGitHub }:

let abc-verifier = callPackage ./abc-verifier.nix { };

in (yosys.override { inherit abc-verifier; }).overrideAttrs (final: prev: {
  version = "unstable-2023-02-24";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "yosys";
    rev = "8216b23fb7b0ee1944403943eb066e0689129ba9";
    hash = "sha256-B57AsYbn2jVLfJwLHrD9jqZcq4gZMRVhAixgcI+YmjQ=";
  };

  postPatch = (prev.postPatch or "") + ''
    sed 's/YOSYS_VER := .*/YOSYS_VER := ${final.version}/g' -i Makefile
  '';

  passthru = prev.passthru // { autoUpdate = "git-commits"; };

  pos.file = ./default.nix; # TODO: this seems like a hack :(
  pos.line = 1;
})
